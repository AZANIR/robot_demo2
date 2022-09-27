# This file contains methods for MGS
import json
import re
from mgs_client import AuthenticatedClient
from mgs_client.models import *
from mgs_client.api.call_rest_controller import call_status_all_1, create_call_1, call_termination_1, call_status_1, \
    delete_call
from mgs_client.api.mgs_configuration_rest_controller import get_all_mgs_configurations
from mgs_client.api.call_generation_profile_rest_controller import get_all_call_profiles, create_call_profile, \
    get_call_profile, delete_call_profile
from mgs_client.types import Response, UNSET, Unset
from config.default import MGS_URL, TOKEN, MGS_CONFIGURATION_NAME, MGS_CALL_PROFILE_NAME

client = AuthenticatedClient(base_url=MGS_URL, token=TOKEN)


def get_all_active_calls_mgs():
    """ Gets all active calls from MGS as list """
    all_active_calls_response: Response[CallExtendedStateV2] = call_status_all_1.sync_detailed(client=client)
    if all_active_calls_response.status_code != 200:
        raise Exception(
            "Failed to obtain active calls from MSG. Response status code: {}".format(
                all_active_calls_response.status_code))

    call_statuses_content_decoded = all_active_calls_response.content.decode('utf8')
    call_statuses_json_data = json.loads(call_statuses_content_decoded)

    active_call_statuses = [call for call in call_statuses_json_data if
                            (call['callState'] == CallExtendedStateV2CallState.ACTIVE)]
    return active_call_statuses


def get_all_call_profiles_mgs():
    """ Gets all call profiles from MGS as list """
    all_call_profiles_response: Response = get_all_call_profiles.sync_detailed(client=client)
    if all_call_profiles_response.status_code != 200:
        raise Exception(
            "Failed to obtain call profiles from MSG. Response status code: {}".format(
                all_call_profiles_response.status_code))

    call_profiles_content_decoded = all_call_profiles_response.content.decode('utf8')
    call_profiles_json_data = json.loads(call_profiles_content_decoded)

    return call_profiles_json_data


def get_call_profile_by_profile_id_mgs(profile_id):
    """ Gets call profile from MGS by profile id """
    call_profile_response: Response = get_call_profile.sync_detailed(profile_id, client=client)
    if call_profile_response.status_code != 200:
        raise Exception(
            "Failed to obtain call profile {} from MSG. Response status code: {}".format(profile_id, call_profile_response.status_code))

    call_profile_content_decoded = call_profile_response.content.decode('utf8')
    call_profile_json_data = json.loads(call_profile_content_decoded)

    return call_profile_json_data


def delete_call_profile_by_profile_id_mgs(profile_id):
    """ Deletes mgs call profile by profile id """
    delete_call_profile_response: Response = delete_call_profile.sync_detailed(profile_id=profile_id, client=client)
    if delete_call_profile_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to delete call profile in MSG. Call profile Id {}. Response status code: {}".format(profile_id, delete_call_profile_response.status_code))


def start_call_mgs(mgs_configuration_id, mgs_call_profile_id):
    """ Starts mgs call and return created call as dictionary """
    start_call_response: Response = create_call_1.sync_detailed(client=client, json_body=StartCallRequest(mgs_configuration_id, mgs_call_profile_id))
    if start_call_response.status_code != 201:
        raise Exception(
            "Failed to create call in MSG. Response status code: {}".format(start_call_response.status_code))
    created_call_decoded = start_call_response.content.decode('utf8')
    return json.loads(created_call_decoded)


def get_call_id_from_call_mgs(call):
    """ Gets mgs call id from call and returns it as string """
    return call['id']


def get_media_sdp_offer_from_call_mgs(call):
    """ Gets mgs media sdp offer message and returns it as string """
    return call['mediaInfo']['sdpOffer']


def get_media_sdp_answer_from_call_mgs(call):
    """ Gets mgs media sdp answer message and returns it as string """
    return call['mediaInfo']['sdpAnswer']


def get_profile_id_from_profile_mgs(profile):
    """ Gets mgs profile id from profile and returns it as string """
    return profile['id']


def get_sip_call_id_from_call_mgs(call):
    """ Gets mgs sip call id from call and returns it as string """
    return call['sipSignallingInfo']['sipDialogInfo']['callId']


def end_call_by_call_id_mgs(call_id):
    """ Ends mgs call by call id """
    end_call_response: Response = call_termination_1.sync_detailed(call_id=call_id, client=client)
    if end_call_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to end (terminate) call in MSG. Call Id {}. Response status code: {}".format(call_id, end_call_response.status_code))


def delete_call_by_call_id_mgs(call_id):
    """ Deletes mgs call by call id """
    delete_call_response: Response = delete_call.sync_detailed(call_id=call_id, client=client)
    if delete_call_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to delete call in MSG. Call Id {}. Response status code: {}".format(call_id, delete_call_response.status_code))


def get_call_status_from_call_mgs(call):
    """ Gets mgs call status from call and returns it as string """
    return call['callState']


def get_sdp_attribute_values_by_attribute_field_mgs(sdp_message: str, attribute_field: str):
    """ Retrieves sdp attribute values by attribute field from sdp message """
    attribute_values = re.findall(f'{attribute_field}=(.*)\r\n', sdp_message)
    return ",".join(attribute_values)


def get_call_status_by_call_id_mgs(call_id):
    """ Gets mgs call state (status) by call id """
    call_state_response: Response = call_status_1.sync_detailed(call_id=call_id, client=client)
    if call_state_response.status_code != 200:
        raise Exception(
            "Failed to obtain call status (state) from MSG. Call Id {}. Response status code: {}".format(call_id, call_state_response.status_code))
    call_state_response_decoded = call_state_response.content.decode('utf8')
    call_state_json_data = json.loads(call_state_response_decoded)
    return call_state_json_data['callState']


def get_call_by_call_id_mgs(call_id):
    """ Gets mgs call by call id """
    call_response: Response = call_status_1.sync_detailed(call_id=call_id, client=client)
    if call_response.status_code != 200:
        raise Exception(
            "Failed to obtain call from MSG. Call Id {}. Response status code: {}".format(call_id, call_response.status_code))
    call_response_decoded = call_response.content.decode('utf8')
    return json.loads(call_response_decoded)


def get_configuration_id_by_name_mgs(name=MGS_CONFIGURATION_NAME):
    """ Gets mgs configuration id (simulator instance id) by configuration name as string """
    # Getting all configurations first
    all_configurations_response: Response = get_all_mgs_configurations.sync_detailed(client=client)
    if all_configurations_response.status_code != 200:
        raise Exception(
            "Failed to obtain all configurations from MSG. Response status code: {}".format(
                all_configurations_response.status_code))
    all_configurations_response_decoded = all_configurations_response.content.decode('utf8')
    all_configurations_json_data = json.loads(all_configurations_response_decoded)
    # Filter configurations by name
    configuration = [configuration for configuration in all_configurations_json_data if
                     (configuration['simulatorInstanceName'] == MGS_CONFIGURATION_NAME)]
    if len(configuration) == 0:
        raise Exception("Configuration {} not found in MSG.".format(name))
    else:
        return configuration[0]['simulatorInstanceId']


def get_profile_id_by_name_mgs(name=MGS_CALL_PROFILE_NAME):
    """ Gets mgs profile id by profile name as string """
    # Getting all profiles first
    all_profiles_response: Response = get_all_call_profiles.sync_detailed(client=client)
    if all_profiles_response.status_code != 200:
        raise Exception(
            "Failed to obtain all profiles from MSG. Response status code: {}".format(
                all_profiles_response.status_code))
    all_profiles_response_decoded = all_profiles_response.content.decode('utf8')
    all_profiles_json_data = json.loads(all_profiles_response_decoded)
    # Filter profiles by name
    profile = [profile for profile in all_profiles_json_data if
               (profile['name'] == MGS_CALL_PROFILE_NAME)]
    if len(profile) == 0:
        raise Exception("Profile {} not found in MSG.".format(name))
    else:
        return profile[0]['id']


def end_all_active_calls_by_configuration_id_mgs(mgs_configuration_id):
    """ Ends mgs active calls by configuration id (simulator instance id) """
    all_active_calls = get_all_active_calls_mgs()
    # Filter active calls by configuration id
    all_active_calls_filtered_by_configuration_id = [call for call in all_active_calls if
                                                     (call['simulatorInstanceId'] == mgs_configuration_id)]
    for active_call in all_active_calls_filtered_by_configuration_id:
        call_id = active_call['id']
        try:
            end_call_by_call_id_mgs(call_id)
        except Exception:
            print("Failed to terminate (end) call {}".format(call_id))


def create_router_nena_e911_call_profile_mgs(name, ani_configuration_mode=NenaE911CallerIdentificationConfigurationAniConfigurationMode.MANUAL,
                                             ani_manual_number=UNSET, ani_auto_telephone_number_template=UNSET, ani_auto_min_range=UNSET,
                                             ani_auto_max_range=UNSET, ani_auto_configuration_mode=CallerIdentificationAutomaticConfigurationMode.INCREMENT,
                                             routing_request_uri=UNSET, transport_protocol=NenaE911TransportConfigurationProtocol.TCP,
                                             voice_enabled=True, media_file_name=UNSET, media_catalog_subtype=MediaFileCatalogSubtype.AUDIO):
    """ Creates mgs call profile ROUTER_NENA_E911 type with specified name and configuration parameters """
    mgs_gateway_profile_type = GatewayProfileType(GatewayProfileType.ROUTER_NENA_E911)
    mgs_caller_identification_configuration = UNSET
    if ani_configuration_mode == NenaE911CallerIdentificationConfigurationAniConfigurationMode.MANUAL:
        mgs_caller_identification_configuration = \
            NenaE911CallerIdentificationConfiguration(NenaE911CallerIdentificationConfigurationAniConfigurationMode.MANUAL, ani_manual=ani_manual_number)
    elif ani_configuration_mode == NenaE911CallerIdentificationConfigurationAniConfigurationMode.AUTOMATIC:
        mgs_caller_identification_automatic_configuration = \
            CallerIdentificationAutomaticConfiguration(ani_auto_telephone_number_template, ani_auto_min_range,
                                                       ani_auto_max_range, ani_auto_configuration_mode)
        mgs_caller_identification_configuration = \
            NenaE911CallerIdentificationConfiguration(NenaE911CallerIdentificationConfigurationAniConfigurationMode.AUTOMATIC, ani_automatic=mgs_caller_identification_automatic_configuration)
    mgs_routing_request_uri = NenaE911RoutingConfiguration(routing_request_uri)
    mgs_transport_protocol = NenaE911TransportConfiguration(transport_protocol)
    mgs_media_file = MediaFile(media_file_name, media_catalog_subtype)
    mgs_media_configuration = NenaE911MediaConfiguration(voice_enabled, mgs_media_file)
    mgs_router_nena_e911_configuration = RouterNenaE911ProfileConfiguration(caller_identification_configuration=mgs_caller_identification_configuration,
                                                                            routing_configuration=mgs_routing_request_uri,
                                                                            transport_configuration=mgs_transport_protocol,
                                                                            media_configuration=mgs_media_configuration)
    create_call_profile_response: Response = create_call_profile.sync_detailed(client=client, json_body=CallGenerationProfile(name=name, profile_configuration=CallProfileConfiguration(gateway_profile_type=mgs_gateway_profile_type, router_nena_e911_configuration=mgs_router_nena_e911_configuration)))
    if create_call_profile_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to create ROUTER_NENA_E911 call profile with name {}. Response status code: {}".format(name, create_call_profile_response.status_code))

    created_call_profile = create_call_profile_response.content.decode('utf8')
    return json.loads(created_call_profile)


def create_router_msi_ccrouter_call_profile_mgs(name, ani_configuration_mode=MsiCcrouterV1CallerIdentificationConfigurationAniConfigurationMode.MANUAL,
                                                ani_manual_number=UNSET, ani_auto_telephone_number_template=UNSET, ani_auto_min_range=UNSET,
                                                ani_auto_max_range=UNSET, ani_auto_configuration_mode=CallerIdentificationAutomaticConfigurationMode.INCREMENT,
                                                outbound_proxy_uri_enabled=False, outbound_proxy_uri=UNSET, to_uri=UNSET, route_uri=UNSET, route_headers_list=UNSET,
                                                transport_protocol=MsiCcrouterV1TransportConfigurationProtocol.TCP,
                                                geolocation_header_format=MsiCcrouterV1CallInformationConfigurationGeolocationHeaderFormat.SINGLE_HEADER,
                                                geolocation_header_value_list=UNSET, call_info_header_provider_info=UNSET,
                                                call_info_header_service_info=UNSET, call_info_header_subscriber_info_enabled=False,
                                                call_info_header_subscriber_info=UNSET, call_info_header_device_info_enabled=False,
                                                call_info_header_device_info=UNSET, call_info_header_comment_enabled=False,
                                                call_info_header_comment=UNSET, voice_enabled=True, media_file_name=UNSET, media_catalog_subtype=MediaFileCatalogSubtype.AUDIO):
    """ Creates mgs call profile ROUTER MSI CCROUTER type with specified name and configuration parameters """
    mgs_gateway_profile_type = GatewayProfileType(GatewayProfileType.ROUTER_MSI_CCROUTER_V1)
    mgs_caller_identification_configuration = UNSET
    if ani_configuration_mode == MsiCcrouterV1CallerIdentificationConfigurationAniConfigurationMode.MANUAL:
        mgs_caller_identification_configuration = \
            MsiCcrouterV1CallerIdentificationConfiguration(MsiCcrouterV1CallerIdentificationConfigurationAniConfigurationMode.MANUAL, ani_manual=ani_manual_number)
    elif ani_configuration_mode == MsiCcrouterV1CallerIdentificationConfigurationAniConfigurationMode.AUTOMATIC:
        mgs_caller_identification_automatic_configuration = \
            CallerIdentificationAutomaticConfiguration(ani_auto_telephone_number_template, ani_auto_min_range,
                                                       ani_auto_max_range, ani_auto_configuration_mode)
        mgs_caller_identification_configuration = \
            MsiCcrouterV1CallerIdentificationConfiguration(MsiCcrouterV1CallerIdentificationConfigurationAniConfigurationMode.AUTOMATIC, ani_automatic=mgs_caller_identification_automatic_configuration)
    mgs_routing_configuration = MsiCcrouterV1RoutingConfiguration(outbound_proxy_uri_enabled,outbound_proxy_uri, to_uri, route_uri, route_headers_list)
    mgs_transport_configuration = MsiCcrouterV1TransportConfiguration(transport_protocol)
    mgs_call_information_configuration = MsiCcrouterV1CallInformationConfiguration(geolocation_header_format, geolocation_header_value_list,
                                                                                   call_info_header_provider_info, call_info_header_service_info,
                                                                                   call_info_header_subscriber_info_enabled, call_info_header_subscriber_info,
                                                                                   call_info_header_device_info_enabled, call_info_header_device_info,
                                                                                   call_info_header_comment_enabled, call_info_header_comment)


    mgs_media_file_configuration = MediaFile(media_file_name, media_catalog_subtype)
    mgs_media_configuration = MsiCcrouterV1MediaConfiguration(voice_enabled, mgs_media_file_configuration)
    mgs_mci_ccrouter_configuration = RouterMsiCcrouterV1ProfileConfiguration(caller_identification_configuration=mgs_caller_identification_configuration,
                                                                             routing_configuration=mgs_routing_configuration,
                                                                             transport_configuration=mgs_transport_configuration,
                                                                             call_information_configuration=mgs_call_information_configuration,
                                                                             media_configuration=mgs_media_configuration)

    create_call_profile_response: Response = create_call_profile.sync_detailed(client=client, json_body=CallGenerationProfile(name=name, profile_configuration=CallProfileConfiguration(gateway_profile_type=mgs_gateway_profile_type, router_msi_ccrouter_v1_configuration=mgs_mci_ccrouter_configuration)))
    if create_call_profile_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to create ROUTER MSI CCROUTER call profile with name {}. Response status code: {}".format(name, create_call_profile_response.status_code))

    created_call_profile = create_call_profile_response.content.decode('utf8')
    return json.loads(created_call_profile)


def create_osp_verizon_nyc_atis_v2_5_call_profile_mgs(name, line_type=OspVerizonNycAtisV25ProfileConfigurationLineType.WIRELESS,
                                                      wireless_pseudo_ani_number_mode=TelephoneNumberGenerationConfigurationMode.MANUAL, wireless_pseudo_ani_number_template=UNSET,
                                                      wireless_pseudo_ani_min_range=UNSET, wireless_pseudo_ani_max_range=UNSET, wireless_callback_ani_number_mode=TelephoneNumberGenerationConfigurationMode.MANUAL,
                                                      wireless_callback_ani_number_template=UNSET, wireless_callback_ani_min_range=UNSET, wireless_callback_ani_max_range=UNSET, wireline_ani_number_mode=TelephoneNumberGenerationConfigurationMode.MANUAL,
                                                      wireline_ani_number_template=UNSET, wireline_ani_min_range=UNSET, wireline_ani_max_range=UNSET, callee_to_uri=UNSET,
                                                      route_uri=UNSET, route_headers_list: list=UNSET, geolocation_header_format=GeolocationHeaderConfigurationGeolocationHeaderFormat.SINGLE_HEADER,
                                                      geolocation_header_value_list: list=UNSET, call_info_header_format=CallInformationHeaderConfigurationCallInfoHeaderFormat.SINGLE_HEADER,
                                                      call_info_header_list: list=UNSET, transport_protocol=VerizonNycAtisV25TransportConfigurationProtocol.TCP,
                                                      voice_enabled=True, media_file_name=UNSET, media_catalog_subtype=MediaFileCatalogSubtype.AUDIO):
    """ Creates mgs call profile OSP_VERIZON_NYC_ATIS_V2_5 type with specified name and configuration parameters """
    mgs_gateway_profile_type = GatewayProfileType(GatewayProfileType.OSP_VERIZON_NYC_ATIS_V2_5)
    mgs_caller_identification_configuration = UNSET
    if line_type == OspVerizonNycAtisV25ProfileConfigurationLineType.WIRELESS:
        mgs_pseudo_ani_number_configuration = TelephoneNumberGenerationConfiguration(wireless_pseudo_ani_number_mode, wireless_pseudo_ani_number_template, wireless_pseudo_ani_min_range, wireless_pseudo_ani_max_range)
        mgs_call_back_number_configuration = TelephoneNumberGenerationConfiguration(wireless_callback_ani_number_mode, wireless_callback_ani_number_template, wireless_callback_ani_min_range, wireless_callback_ani_max_range)
        mgs_wireless_configuration = VerizonNycAtisV25CallerIdentificationWirelessConfiguration(mgs_pseudo_ani_number_configuration, mgs_call_back_number_configuration)
        mgs_caller_identification_configuration = VerizonNycAtisV25CallerIdentificationConfiguration(wireless_configuration=mgs_wireless_configuration)
    elif line_type == OspVerizonNycAtisV25ProfileConfigurationLineType.WIRELINE:
        mgs_ani_number_configuration = TelephoneNumberGenerationConfiguration(wireline_ani_number_mode, wireline_ani_number_template, wireline_ani_min_range, wireline_ani_max_range)
        mgs_wireline_configuration = VerizonNycAtisV25CallerIdentificationWirelineConfiguration(mgs_ani_number_configuration)
        mgs_caller_identification_configuration = VerizonNycAtisV25CallerIdentificationConfiguration(wireline_configuration=mgs_wireline_configuration)

    mgs_callee_identification_configuration = VerizonNycAtisV25CalleeIdentificationConfiguration(callee_to_uri)
    mgs_routing_configuration = VerizonNycAtisV25RoutingConfiguration(route_uri, route_headers_list)
    mgs_geolocation_list = []
    if not isinstance(geolocation_header_value_list, Unset) and len(geolocation_header_value_list) != 0:
        for call_info_header_value in geolocation_header_value_list:
            data_transmission_mode = GeolocationHeaderDataTransmissionMode(call_info_header_value['data_transmission_mode'])
            header_value = call_info_header_value['header_value']
            mime_content_mode = GeolocationHeaderMimeContentMode(call_info_header_value['mime_content_mode'])
            mime_content = call_info_header_value['mime_content']
            geolocation_header = GeolocationHeader(data_transmission_mode, header_value, mime_content_mode, mime_content)
            mgs_geolocation_list.append(geolocation_header)
    mgs_geolocation_header_configuration = GeolocationHeaderConfiguration(geolocation_header_format, mgs_geolocation_list)
    mgs_call_info_header_list = []
    if not isinstance(call_info_header_list, Unset) and len(call_info_header_list) != 0:
        for call_info_header_value in call_info_header_list:
            call_info_header_type = CallInfoHeaderCallInfoHeaderType(call_info_header_value['call_info_header_type'])
            data_transmission_mode = CallInfoHeaderDataTransmissionMode(call_info_header_value['data_transmission_mode'])
            header_value = call_info_header_value['header_value']
            mime_content_mode = CallInfoHeaderMimeContentMode(call_info_header_value['mime_content_mode'])
            mime_content = call_info_header_value['mime_content']
            call_info_header = CallInfoHeader(call_info_header_type,data_transmission_mode, header_value, mime_content_mode, mime_content)
            mgs_call_info_header_list.append(call_info_header)
    mgs_call_information_header_configuration = CallInformationHeaderConfiguration(call_info_header_format, mgs_call_info_header_list)
    mgs_call_information_configuration = VerizonNycAtisV25CallInformationConfiguration(mgs_geolocation_header_configuration, mgs_call_information_header_configuration)
    mgs_transport_configuration = VerizonNycAtisV25TransportConfiguration(transport_protocol)
    mgs_media_file = MediaFile(media_file_name, media_catalog_subtype)
    mgs_media_configuration = VerizonNycAtisV25MediaConfiguration(voice_enabled, mgs_media_file)
    mgs_osp_verizon_nyc_atis_v2_5_profile_configuration = OspVerizonNycAtisV25ProfileConfiguration(line_type=line_type, caller_identification_configuration=mgs_caller_identification_configuration,
                                                                                                   callee_identification_configuration=mgs_callee_identification_configuration,
                                                                                                   routing_configuration=mgs_routing_configuration, call_information_configuration=mgs_call_information_configuration,
                                                                                                   transport_configuration=mgs_transport_configuration, media_configuration=mgs_media_configuration)

    create_call_profile_response: Response = create_call_profile.sync_detailed(client=client, json_body=CallGenerationProfile(name=name, profile_configuration=CallProfileConfiguration(gateway_profile_type=mgs_gateway_profile_type,osp_verizon_nyc_atis_v2_5_profile_configuration=mgs_osp_verizon_nyc_atis_v2_5_profile_configuration)))
    if create_call_profile_response.status_code not in range(200, 300):
        raise Exception(
            "Failed to create OSP VERIZON NYC ATIS V2.5 call profile with name {}. Response status code: {}".format(name, create_call_profile_response.status_code))

    created_call_profile = create_call_profile_response.content.decode('utf8')
    return json.loads(created_call_profile)
