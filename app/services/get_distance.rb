class GetDistance < ActiveInteraction::Base
    R = 6371

    object :a, class: Point
    object :b, class: Point

    def execute
        phi_a = a.lat * Math::PI/180
        phi_b = b.lat * Math::PI/180
        delta_phi = (b.lat - a.lat) * (Math::PI / 180)
        delta_lambda = (b.lng - a.lng) * (Math::PI / 180)
        x = Math.sin(delta_phi / 2) * Math.sin(Math.sin(delta_phi / 2)) + Math.cos(phi_a) * Math.cos(phi_b) * Math.sin(delta_lambda / 2) * Math.sin(delta_lambda / 2)
        y = 2 * Math.atan2(Math.sqrt(x), Math.sqrt(1 - x))
        (R * y).round
    end
end
