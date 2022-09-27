# This file contains methods for CHE
import json
import re
from psap_simulator_client import AuthenticatedClient
from psap_simulator_client.api.call_handling_profile_rest_controller import update_call_handling_profile
from psap_simulator_client.api.call_handling_rest_controller import get_all_calls, get_call, \
    get_last_call_notifications, delete_all_calls, delete_call, end_call, pickup_call, redirect, reinvite
from psap_simulator_client.models import CallExtendedState, CallExtendedStateCallStatus, CallHandlingProfile
from psap_simulator_client.types import Response

from config.default import CHE_URL, TOKEN, SIP_ENDPOINT_ID

client = AuthenticatedClient(base_url=CHE_URL, token=TOKEN)


def get_all_calls_che():
    """ Get all calls from CHE as list """
    response: Response[CallExtendedState] = get_all_calls.sync_detailed(client=client)
    status_call(response, 200, "get all calls")
    response_json_data = decode_to_json(response)
    return response_json_data['callExtendedStateList']


def get_all_calls_with_status_che(status_callback: str = CallExtendedStateCallStatus.ACTIVE):
    """ Get all calls with status from CHE as list (default status is ACTIVE) """
    response: Response[CallExtendedState] = get_all_calls.sync_detailed(client=client)
    status_call(response, 200, "get all calls with status")
    response_json_data = decode_to_json(response)
    active_call_statuses = [call for call in response_json_data['callExtendedStateList'] if
                            (call['callStatus'] == status_callback)]
    return active_call_statuses


def get_call_status_by_call_id_che(call_id: str):
    """ Get CHE call state (status) by call id """
    call_state_response = get_call_with_id_che(call_id)
    return call_state_response['callStatus']


def get_call_with_id_che(call_id: str):
    """ Get call with id from CHE and returns it as dictionary """
    response: Response[CallExtendedState] = get_call.sync_detailed(call_id, client=client)
    status_call(response, 200, "get call with id")
    response_json_data = decode_to_json(response)
    return response_json_data['callExtendedState']


def get_all_participation_notification_che(call_id: str):
    """ Get all participation notification from CHE as list """
    response: Response[CallExtendedState] = get_last_call_notifications.sync_detailed(call_id, client=client)
    status_call(response, 200, "get all participation notification")
    response_json_data = decode_to_json(response)
    return response_json_data


def get_all_participation_notification_with_count_che(call_id: str, last: int):
    """ Get last counted participation notification from CHE as list """
    response: Response[CallExtendedState] = get_last_call_notifications.sync_detailed(call_id, client=client, last=last)
    status_call(response, 200, "get last counted participation notification")
    response_json_data = decode_to_json(response)
    return len(response_json_data)


def delete_all_calls_che():
    """ Deletes all calls from CHE """
    response: Response[CallExtendedState] = delete_all_calls.sync_detailed(client=client)
    status_call(response, 200, "delete all calls")
    return response.status_code


def delete_call_with_id_che(call_id: str):
    """ Deletes call with id from CHE """
    response: Response[CallExtendedState] = delete_call.sync_detailed(call_id, client=client)
    status_call(response, 200, "delete call with id")
    return response.status_code


def end_call_with_id_che(call_id: str):
    """ Ends call with id from CHE """
    response: Response[CallExtendedState] = end_call.sync_detailed(call_id, client=client)
    status_call(response, 200, "end call with id")
    return response.status_code


def pickup_call_with_id_che(call_id: str):
    """ Picks up call with id from CHE """
    response: Response[CallExtendedState] = pickup_call.sync_detailed(call_id, client=client)
    status_call(response, 200, "pickup call with id")
    return response.status_code


def redirect_call_with_id_che(call_id: str, redirect_to: str):
    """ Redirects call with id from CHE """
    response: Response[CallExtendedState] = redirect.sync_detailed(call_id, redirect_to, client=client)
    status_call(response, 200, "redirect call with id")
    return response.status_code


def reinvite_call_with_id_che(call_id: str, reinvite_to: str):
    """ Reinvites call with id from CHE """
    response: Response[CallExtendedState] = reinvite.sync_detailed(call_id, reinvite_to, client=client)
    status_call(response, 200, "reinvite call with id")
    return response.status_code


def decode_to_json(response: Response[CallExtendedState]):
    """ Decodes response to json """
    decoded_response = response.content.decode('utf8')
    response_json_data = json.loads(decoded_response)
    return response_json_data


def status_call(response: Response[CallExtendedState], code: int, text_message: str):
    """ get status code from response and return it """
    status_code = response.status_code
    if response.status_code != code:
        raise Exception(
            "Failed to {text} from CHE. Response status code: {status_code}".format(text=text_message,
                                                                                    status_code=status_code))

    return response.status_code


def end_all_active_calls_che():
    """ Ends CHE active calls by configuration id (simulator instance id) """
    all_active_calls = get_all_calls_with_status_che()
    for active_call in all_active_calls:
        call_id = active_call['id']
        try:
            end_call_with_id_che(call_id)
        except Exception:
            print("Failed to terminate (end) call {}".format(call_id))


def update_call_handling_profile_che(auto_pickup: bool, media_enabled: bool, sip_endpoint_id: str = SIP_ENDPOINT_ID):
    """ Updates call handling profile (enable or disable call auto pick up, media) """
    response: Response = update_call_handling_profile.sync_detailed(sip_endpoint_id=sip_endpoint_id, client=client,
                                                                    json_body=CallHandlingProfile(
                                                                        sip_endpoint_id=sip_endpoint_id,
                                                                        auto_pickup=auto_pickup,
                                                                        media_enabled=media_enabled))
    status_call(response, 200, "update call handling profile")
    return response.status_code


def get_call_phone_by_call_id_che(call_id: str):
    """ Get call phone from CHE """
    phone = re.search(r'(?<=tel:)[\d+-]+', get_call_original_invite_by_call_id_che(call_id))
    if phone:
        return phone.group(0).replace('-', '').replace('+', '')
    else:
        return "Phone is not found!"


def get_call_position_by_call_id_che(call_id: str):
    """ Get call position from CHE """
    location = re.search(r'(?<=<pos>).*?(?=</pos>)', get_call_original_invite_by_call_id_che(call_id))
    if location:
        return location.group(0)
    else:
        return "Position is not found!"


def get_call_location_by_call_id_che(call_id: str):
    """ Get call location from CHE """
    arr = []
    reg_address = r'<country[\w\W]*?(?=</civicAddress>)'
    reg_arr = [r'(?<=<country>).*?(?=</country>)', r'(?<=<A1>).*?(?=</A1>)', r'(?<=<A2>).*?(?=</A2>)',
               r'(?<=<A3>).*?(?=</A3>)', r'(?<=<RD>).*?(?=</RD>)', r'(?<=<HNO>).*?(?=</HNO>)',
               r'(?<=<PC>).*?(?=</PC>)', r'(?<=<NAM>).*?(?=</NAM>)', r'(?<=\">)\w+(?=</COMM)',
               r'(?<=\">)\w+(?=</ESN>)']
    pre_address = re.search(reg_address, get_call_original_invite_by_call_id_che(call_id))
    if pre_address:
        for element in reg_arr:
            search_result = re.search(element, pre_address.group(0))
            if search_result:
                arr.append(search_result.group(0))
        return ', '.join(arr)
    else:
        return "Location is not found!"


def get_call_media_session_info_by_call_id_che(call_id: str):
    """ Get call current session media info from CHE """
    return get_call_with_id_che(call_id)['currentMediaSessionInfo']


def get_call_media_enabled_by_call_id_che(call_id: str):
    """ Get call handling parameters media enabled from CHE """
    return get_call_with_id_che(call_id)['callHandlingParameters']['mediaEnabled']


def get_call_handling_parameters_media_endpoint_id_by_call_id_che(call_id: str):
    """ Get call handling parameters media endpoint id from CHE """
    return get_call_with_id_che(call_id)['callHandlingParameters']['mediaEndpointId']


def get_call_current_media_session_id_by_call_id_che(call_id: str):
    """ Get call current session media info id from CHE """
    return get_call_media_session_info_by_call_id_che(call_id)['id']


def get_call_current_session_media_endpoint_id_by_call_id_che(call_id: str):
    """ Get call current session media info endpoint id from CHE """
    return get_call_media_session_info_by_call_id_che(call_id)['mediaEndpointInstanceId']


def get_call_current_media_session_rtp_element_id_by_call_id_che(call_id: str):
    """ Get call current session media info rtp element id from CHE """
    return get_call_media_session_info_by_call_id_che(call_id)['rtpElementId']


def get_call_current_media_session_sdp_offer_by_call_id_che(call_id: str):
    """ Get call current session media info sdp offer from CHE """
    return get_call_media_session_info_by_call_id_che(call_id)['sdpOffer']


def get_call_current_media_session_sdp_answer_by_call_id_che(call_id: str):
    """ Get call current session media info sdp answer from CHE """
    return get_call_media_session_info_by_call_id_che(call_id)['sdpAnswer']


def get_sdp_attribute_values_by_attribute_field_che(sdp_message: str, attribute_field: str):
    """ Retrieves sdp attribute values by attribute field from sdp message """
    attribute_values = re.findall(f'{attribute_field}=(.*)\r\n', sdp_message)
    return ",".join(attribute_values)


def get_call_target_uri_by_call_id_che(call_id: str):
    """ Get call target uri from CHE """
    return get_call_with_id_che(call_id)['targetUri']


def get_call_transport_protocol_by_call_id_che(call_id: str):
    """ Get call transport protocol from CHE """
    return get_call_with_id_che(call_id)['transportProtocol']


def get_call_info_local_tag_by_call_id_che(call_id: str):
    """ Get call info local tag from CHE """
    return get_call_with_id_che(call_id)['callInfo']['localTag']


def get_call_info_remote_tag_by_call_id_che(call_id: str):
    """ Get call info remote tag from CHE """
    return get_call_with_id_che(call_id)['callInfo']['remoteTag']


def get_call_error_message_by_call_id_che(call_id: str):
    """ Get call error message from CHE """
    return get_call_with_id_che(call_id)['errorMessage']


def get_call_original_invite_by_call_id_che(call_id: str):
    """ Get call original invite from CHE """
    return get_call_with_id_che(call_id)['originalInvite']


def get_call_previous_media_session_info_by_call_id_che(call_id: str):
    """ Get call previous media session info from CHE """
    return get_call_with_id_che(call_id)['previousMediaSessionInfo']


def get_call_sip_endpoint_id_by_call_id_che(call_id: str):
    """ Get call sip endpoint id from CHE """
    return get_call_with_id_che(call_id)['sipEndpointId']


def get_call_handling_parameters_by_call_id_che(call_id: str):
    """ Get call handling parameters from CHE """
    return get_call_with_id_che(call_id)['callHandlingParameters']


def get_call_handling_parameters_auto_pickup_by_call_id_che(call_id: str):
    """ Get call handling parameters auto pickup from CHE """
    return get_call_handling_parameters_by_call_id_che(call_id)['autoPickup']
