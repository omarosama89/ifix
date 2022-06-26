class GetRequestPrice < ActiveInteraction::Base
    array :provider_service_ids

    def execute
        provider_services = ProviderService.where(id: provider_service_ids)
        provider_services.map(&:price).sum
    end
end
