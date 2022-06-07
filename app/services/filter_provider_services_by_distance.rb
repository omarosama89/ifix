class FilterProviderServicesByDistance < ActiveInteraction::Base
    object :point
    array :provider_services do
        object class: ProviderService
    end
    integer :max_distance

    def execute
        provider_services.select do |provider_service|
            GetDistance.run!(a: point, b: convert_object_to_point(provider_service.provider)) <= max_distance
        end
    end

    private

    def convert_object_to_point(obj)
        Point.new(lat: obj.lat, lng: obj.lng)
    end
end
