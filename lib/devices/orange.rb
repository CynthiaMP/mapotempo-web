# Copyright © Mapotempo, 2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
class Orange < DeviceBase

  require "builder" # XML
  require "addressable"

  def test_list params
    @auth = params.slice :user, :password
    send_request list_operations({ eqpid: "", dtdeb: Time.now.beginning_of_day, dtfin: Time.now.end_of_day })
  end

  def list_devices
    response = send_request(get_vehicles)
    if response.code.to_i == 200
      vehicle_infos = []
      Nokogiri::XML(response.body).xpath("//vehicle").each_with_object({}) do |item, hash|
        item.children.select(&:element?).map{|node| hash[node.name] = node.inner_html }
        vehicle_infos << hash
      end
      vehicle_infos.map do |item|
        { id: item["esht"], text: "%s - %s" % [ item["vdes"], item["vreg"] ] }
      end
    else
      raise DeviceServiceError.new("Orange: %s" % [ I18n.t('errors.orange.list') ])
    end
  end

  def send_route options
    @route = options[:route]
    send_request(send_xml_file)
  end

  def clear_route options
    # Ça n’est pas possible sur les 590 (qui n’utilsent pas le même protocol de transmission). Uniquement sur Garmin Dezl et Nuvi.
    @route = options[:route]
    send_request send_xml_file(delete: true)
  end

  def get_vehicles_pos
    response = send_request(get_positions)
    if response.code.to_i == 200
      vehicle_infos = []
      Nokogiri::XML(response.body).xpath("//position").each_with_object({}) do |item, hash|
        item.children.select(&:element?).map{|node| hash[node.name] = node.inner_html }
        vehicle_infos << { orange_vehicle_id: hash["esht"], lat: hash["lat"], lng: hash["lon"], speed: hash["speed"], time: hash["hd"], device_name: hash["vdes"] }
      end
      return vehicle_infos
    else
      raise DeviceServiceError.new("Orange: %s" % [ I18n.t('errors.orange.get_vehicles_pos') ])
    end
  end

  private

  def send_request response
    if response.code.to_i == 200
      return response
    elsif response.code.to_i == 401
      raise DeviceServiceError.new I18n.t("errors.orange.unauthorized")
    else
      Rails.logger.info "OrangeService: %s %s" % [response.code, response.body]
    end
  end

  def net_request options
    # Auth
    if auth
      user, password = auth[:user], auth[:password]
    else
      user, password = customer.orange_user, customer.orange_password
    end

    # HTTP Request w/ SSL
    uri = URI.parse api_url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # GET Data
    request = Net::HTTP::Get.new options[:path]
    request.basic_auth user, password
    request.set_form_data options[:params]
    http.request request
  end

  def get_positions
    net_request path: "/webservices/getpositions.php", params: { ext: "xml" }
  end

  def get_vehicles
    net_request path: "/webservices/getvehicles.php", params: { ext: "xml" }
  end

  def list_operations options
    net_request path: "/pnd/index.php", params: { ext: "xml", ref: "", vehid: "", typ: "mis" }
  end

  def send_xml_file options={}
    f = Tempfile.new Time.now.to_i.to_s ; f.write to_xml(options) ; f.rewind
    response = RestClient::Request.execute method: :post, user: customer.orange_user, password: customer.orange_password, url: api_url + "/pnd/index.php", payload: { multipart: true, file: f }
    f.unlink
    return response
  end

  def to_xml options={}
    xml = ::Builder::XmlMarkup.new indent: 2
    xml.instruct!
    xml.tag! :ROOT do
      xml.tag! :version
      xml.tag! :transmit, Time.now.strftime("%d/%m/%Y %H:%M")
      xml.tag! :zone, nil, type: "dest", ref: route.id, eqpid: route.vehicle_usage.vehicle.orange_id, drivername: nil, vehid: nil, badge: nil
      xml.tag! :zone, nil, type: "mission", ref: route.id, lang: nil, title: "Mission #{route.id}", txt: route.planning.name,
        prevmisdeb: p_time(route.start).strftime("%d/%m/%Y %H:%M"), prevmisfin: p_time(route.end).strftime("%d/%m/%Y %H:%M")
      xml.tag! :zone, nil, type: "operation" do
        route.stops.select(&:active?).select(&:position?).sort_by(&:index).each do |stop|
          xml.tag! :operation, nil, options.merge(seq: stop.index, ad1: stop.street, ad2: nil, ad3: nil, ad_zip: stop.postalcode,
            ad_city: stop.city, ad_cntry: "FR", latitude: stop.lat, longitude: stop.lng, title: stop.name, txt: [stop.street, stop.postalcode, stop.city].join(", "),
            prevopedeb: p_time(stop.open || stop.time).strftime("%d/%m/%Y %H:%M"), prevopefin: p_time(stop.close || stop.time).strftime("%d/%m/%Y %H:%M"))
        end
      end
    end
  end

end
