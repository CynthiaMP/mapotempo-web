// Copyright © Mapotempo, 2013-2015
//
// This file is part of Mapotempo.
//
// Mapotempo is free software. You can redistribute it and/or
// modify since you respect the terms of the GNU Affero General
// Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Mapotempo is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Mapotempo. If not, see:
// <http://www.gnu.org/licenses/agpl.html>
//
var customers_index = function(params) {
  var map_layers = params.map_layers,
    map_attribution = params.map_attribution;

  var is_map_init = false;

  var map_init = function() {
    var map = mapInitialize(params);
    L.control.attribution({prefix: false}).addTo(map);

    var layer = L.featureGroup();
    map.addLayer(layer);

    var display_customers = function(data) {
      $.each(data.customers, function(i, customer) {
        var marker = L.marker(new L.LatLng(customer.lat, customer.lng), {
          icon: new L.NumberedDivIcon({
            number: customer.max_vehicles,
            iconUrl: '/images/point-' + (customer.test ? '707070' : '004499') + '.svg',
            iconSize: new L.Point(12, 12),
            iconAnchor: new L.Point(6, 6),
            popupAnchor: new L.Point(0, -6),
            className: "small"
          })
        }).addTo(layer).bindPopup(customer.name);
      });

      map.invalidateSize();
      if (layer.getLayers().length > 0) {
        map.fitBounds(layer.getBounds().pad(1.1), {
          maxZoom: 15
        });
      }
    }

    $.ajax({
      url: '/customers.json',
      beforeSend: beforeSendWaiting,
      success: display_customers,
      complete: completeWaiting,
      error: ajaxError
    });
  };

  $('#accordion').on('show.bs.collapse', function(event, ui) {
    if (!is_map_init) {
      is_map_init = true;
      map_init();
    }
  });
}

var customers_edit = function(params) {

  /* API: Devices */
  devices_observe_customer($.extend(params, { default_password: Math.random().toString(36).slice(-8) } ));

  $('#customer_end_subscription').datepicker({
    language: defaultLocale,
    autoclose: true,
    todayHighlight: true
  });

  $('#customer_take_over').timeEntry({
    show24Hours: true,
    showSeconds: true,
    initialField: 1,
    defaultTime: new Date(0, 0, 0, 0, 0, 0),
    spinnerImage: ''
  });

  $.fn.wysihtml5.locale['fr'] = $.fn.wysihtml5.locale['fr-FR'];
  $('#customer_print_header').wysihtml5({
    toolbar: {
      link: false,
      image: false,
      blockquote: false,
      size: 'sm',
      fa: true
    },
    locale: defaultLocale
  });
}

Paloma.controller('Customer').prototype.index = function() {
  customers_index(this.params);
};

Paloma.controller('Customer').prototype.new = function() {
  customers_edit(this.params);
};

Paloma.controller('Customer').prototype.create = function() {
  customers_edit(this.params);
};

Paloma.controller('Customer').prototype.edit = function() {
  customers_edit(this.params);
};

Paloma.controller('Customer').prototype.update = function() {
  customers_edit(this.params);
};
