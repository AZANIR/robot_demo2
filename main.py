from mgs_client import AuthenticatedClient
from mgs_client.models import CallProfileConfiguration
from mgs_client.api.call_generation_profile_rest_controller import get_all_call_profiles
from mgs_client.types import Response

from config.default import MGS_URL, CHE_URL, TOKEN

client = AuthenticatedClient(base_url=MGS_URL, token=TOKEN)

response: Response[CallProfileConfiguration] = get_all_call_profiles.sync_detailed(client=client)
print(response.content)