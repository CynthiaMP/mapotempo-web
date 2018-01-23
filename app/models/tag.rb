# Copyright © Mapotempo, 2013-2016
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
class Tag < ApplicationRecord
  ICON_SIZE = %w(small medium large).freeze

  default_scope { order(:label) }

  belongs_to :customer
  has_and_belongs_to_many :destinations
  has_and_belongs_to_many :visits
  has_and_belongs_to_many :plannings

  nilify_blanks before: :validation
  auto_strip_attributes :label

  validates :label, presence: true
  validates :ref, uniqueness: { scope: :customer_id, case_sensitive: true }, allow_nil: true, allow_blank: true
  validates_format_of :color, with: /\A(|\#[A-Fa-f0-9]{6})\Z/, allow_nil: true

  validates_inclusion_of :icon, in: FontAwesome::ICONS_TABLE, allow_nil: true, message: ->(*_) { I18n.t('activerecord.errors.models.tag.icon_unknown') }
  validates :icon_size, inclusion: { in: Tag::ICON_SIZE, allow_nil: true, message: ->(*_) { I18n.t('activerecord.errors.models.tag.icon_size_invalid') } }

  include RefSanitizer

  before_update :update_outdated

  amoeba do
    exclude_association :visits
    exclude_association :plannings
    exclude_association :destinations

    customize( lambda { |original, copy|
      def copy.update_outdated; end
    })
  end

  def default_color
    color || Mapotempo::Application.config.tag_color_default
  end

  def default_icon
    icon || Mapotempo::Application.config.tag_icon_default
  end

  def default_icon_size
    icon_size || Mapotempo::Application.config.tag_icon_size_default
  end

  private

  def outdated
    Route.transaction do
      # Local function should be called outside update for planning/route
      # => Allow using different graph
      Route.where(id: (destinations.flat_map(&:visits) | visits).flat_map{ |v| v.stop_visits.map(&:route_id) }.uniq).each{ |route|
        route.outdated = true
        route.save!
      }
    end
  end

  def update_outdated
    if color_changed? || icon_changed? || icon_size_changed?
      outdated
    end
  end
end
