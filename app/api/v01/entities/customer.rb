# Copyright © Mapotempo, 2014-2015
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
class V01::Entities::Customer < Grape::Entity
  def self.entity_name
    'V01_Customer'
  end
  EDIT_ONLY_ADMIN = 'Only available in admin.'.freeze

  # expose(:reseller_id, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:id, documentation: { type: Integer })
  expose(:end_subscription, documentation: { type: Date, desc: EDIT_ONLY_ADMIN })

  # Default
  expose(:store_ids, documentation: { type: Integer, is_array: true })
  expose(:vehicle_usage_set_ids, documentation: { type: Integer, is_array: true })
  expose(:deliverable_unit_ids, documentation: { type: Integer, is_array: true })

  expose(:ref, documentation: { type: String, desc: EDIT_ONLY_ADMIN })
  expose(:name, documentation: { type: String, desc: EDIT_ONLY_ADMIN })
  # expose(:test, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:take_over, documentation: { type: DateTime, desc: 'Visit duration' }) { |m| m.take_over_time_with_seconds }
  expose(:default_country, documentation: { type: String })
  expose(:profile_id, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:router_id, documentation: { type: Integer })
  expose(:router_dimension, documentation: { type: String, values: ::Router::DIMENSION.keys })
  # FIXME: RouterOptions entity can only be used to display results, otherwise swagger-ui interface is broken but tests are ok. Entities are working correctly only with is_array.
  expose(:router_options, using: V01::Entities::RouterOptions, documentation: { type: V01::Entities::RouterOptions })
  expose(:speed_multiplicator, documentation: { type: Float, desc: 'Deprecated, use speed_multiplier instead.' }) { |m| m.speed_multiplier }
  expose(:speed_multiplier, documentation: { type: Float })

  expose(:print_planning_annotating, documentation: { type: 'Boolean' })
  expose(:print_header, documentation: { type: String })
  expose(:print_barcode, documentation: { type: String, values: ::Customer::PRINT_BARCODE, desc: 'Print the Reference as Barcode'})
  expose(:sms_template, documentation: { type: String })
  expose(:sms_concat, documentation: { type: 'Boolean' })
  expose(:sms_from_customer_name, documentation: { type: 'Boolean' })

  expose(:enable_references, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_multi_visits, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_global_optimization, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_vehicle_position, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_stop_status, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  expose(:enable_sms, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })

  expose(:optimization_max_split_size, documentation: { type: Integer, desc: 'Maximum number of visits to split problem', default: Mapotempo::Application.config.optimize_max_split_size })
  expose(:optimization_cluster_size, documentation: { type: Integer, desc: 'Time in seconds to group near visits', default: Mapotempo::Application.config.optimize_cluster_size })
  expose(:optimization_time, documentation: { type: Integer, desc: 'Maximum optimization time (by vehicle)', default: Mapotempo::Application.config.optimize_time })
  expose(:optimization_stop_soft_upper_bound, documentation: { type: Float, desc: 'Stops delay coefficient, 0 to avoid delay', default: Mapotempo::Application.config.optimize_stop_soft_upper_bound })
  expose(:optimization_vehicle_soft_upper_bound, documentation: { type: Float, desc: 'Vehicles delay coefficient, 0 to avoid delay', default: Mapotempo::Application.config.optimize_vehicle_soft_upper_bound })
  expose(:optimization_cost_waiting_time, documentation: { type: Float, desc: 'Coefficient to manage waiting time', default: Mapotempo::Application.config.optimize_cost_waiting_time })
  expose(:optimization_force_start, documentation: { type: 'Boolean', desc: 'Force time for departure', default: Mapotempo::Application.config.optimize_force_start })

  expose(:advanced_options, documentation: { type: String, desc: 'Advanced options in a serialized json format' })

  expose(:max_vehicles, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:max_plannings, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:max_zonings, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:max_destinations, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })
  expose(:max_vehicle_usage_sets, documentation: { type: Integer, desc: EDIT_ONLY_ADMIN })

  expose(:job_destination_geocoding_id, documentation: { type: Integer })
  expose(:job_store_geocoding_id, documentation: { type: Integer })
  expose(:job_optimizer_id, documentation: { type: Integer })

  expose(:devices, documentation: { type: Hash, desc: EDIT_ONLY_ADMIN })

  # # Devices: Alyacom
  # expose(:enable_alyacom, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:alyacom_association, documentation: { type: String })

  # # Devices: Masternaut
  # expose(:enable_masternaut, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:masternaut_user, documentation: { type: String })

  # # Devices: Orange
  # expose(:enable_orange, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:orange_user, documentation: { type: String })

  # # Devices: Teksat
  # expose(:enable_teksat, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:teksat_customer_id, documentation: { type: Integer })
  # expose(:teksat_username, documentation: { type: String })
  # expose(:teksat_url, documentation: { type: String })

  # # Devices: TomTom
  # expose(:enable_tomtom, documentation: { type: 'Boolean', desc: EDIT_ONLY_ADMIN })
  # expose(:tomtom_user, documentation: { type: String })
  # expose(:tomtom_account, documentation: { type: String })

end

class V01::Entities::CustomerAdmin < V01::Entities::Customer
  def self.entity_name
    'V01_CustomerAdmin'
  end
  EDIT_ONLY_ADMIN = 'Only available in admin.'.freeze

  expose(:description, documentation: { type: String, desc: EDIT_ONLY_ADMIN })
end
