*** Settings ***
Documentation   Keywords for querying MGS API.
Library    Collections
Library    ../../../helpers/mgs/mgs.py


*** Variables ***
${created_call_status}    CREATED
${ended_call_status}    ENDED
${failed_call_status}    FAILED
${active_call_status}    ACTIVE
${proceeding_call_status}   PROCEEDING
${call_profile_manual_ani_configuration_mode}    MANUAL
${call_profile_auto_ani_configuration_mode}    AUTOMATIC
${default_call_profile_transport_protocol}    TCP
${default_call_profile_voice_enabled}    ${True}
${default_call_profile_media_catalog_subtype}    AUDIO
${default_call_profile_ani_auto_configuration_mode}    INCREMENT
${default_call_profile_geolocation_header_format}    SINGLE_HEADER
${wireless_call_profile_line_type}    WIRELESS
${wireline_call_profile_line_type}    WIRELINE


*** Keywords ***
MGS Start Call
    [Documentation]    Starts mgs call and returns created call
    [Arguments]    ${mgs_configuration_id}    ${mgs_call_profile_id}
    ${started_call}=    start call mgs    ${mgs_configuration_id}    ${mgs_call_profile_id}
    Log    Started call: ${started_call}
    ${call_id}=    get call id from call mgs    ${started_call}
    Should Not Be Empty    ${call_id}
    ${call_status}=    get call status from call mgs     ${started_call}
    Should Be Equal    ${created_call_status}    ${call_status}

    [Return]    ${started_call}

MGS Get Call
    [Documentation]    Gets mgs call and returns it
    [Arguments]    ${mgs_call_id}
    ${mgs_call}=    get call by call id mgs    ${mgs_call_id}
    Log    MGS call: ${mgs_call}
    ${call_id}=    get call id from call mgs    ${mgs_call}
    Should Not Be Empty    ${call_id}

    [Return]    ${mgs_call}

MGS Get Active Calls
    [Documentation]    Gets all active calls from MGS
    ${active_calls}=    get all active calls mgs
    Log    Active calls: ${active_calls}

    [Return]    ${active_calls}

MGS Get All Call Profiles
    [Documentation]    Gets all call profiles from MGS
    ${call_profiles}=    get all call profiles mgs
    Log    All call profiles: ${call_profiles}

    [Return]    ${call_profiles}

MGS Get Call Profile
    [Documentation]    Gets call profile by profile id from MGS
    [Arguments]    ${profile_id}
    ${call_profile}=    get call profile by profile id mgs    ${profile_id}
    Log    Call profile: ${call_profile}

    [Return]    ${call_profile}

MGS Get Call Profile Id From Profile
    [Documentation]    Gets call profile id from MGS profile
    [Arguments]    ${profile}
    ${call_profile_id}=    get profile id from profile mgs    ${profile}
    Log    Call profile id: ${call_profile_id}

    [Return]    ${call_profile_id}

MGS Delete Call Profile
    [Documentation]    Deletes call profile in MGS by call id
    [Arguments]    ${profile_id}
    delete call profile by profile id mgs    ${profile_id}

MGS Get Call Status
    [Documentation]    Gets call status from MGS by call id
    [Arguments]    ${call_id}
    ${call_status}=    get call status by call id mgs    ${call_id}
    Log    Call status (state): ${call_status}
    Should Not Be Empty    ${call_status}

    [Return]    ${call_status}

MGS Get Call Id From Call
    [Documentation]    Gets call id from MGS call
    [Arguments]    ${call}
    ${call_id}=    get call id from call mgs    ${call}
    Log    Call id: ${call_id}
    Should Not Be Empty    ${call_id}

    [Return]    ${call_id}

MGS Get Sip Call Id From Call
    [Documentation]    Gets sip call id from MGS call
    [Arguments]    ${call}
    ${sip_call_id}=    get sip call id from call mgs    ${call}
    Log    Sip call id: ${sip_call_id}
    Should Not Be Empty    ${sip_call_id}

    [Return]    ${sip_call_id}

MGS Get Media SDP Offer Message From Call
    [Documentation]    Gets sdp offer message from MGS call
    [Arguments]    ${call}
    ${sdp_offer}=    get media sdp offer from call mgs    ${call}
    Log    SDP offer message: ${sdp_offer}

    [Return]    ${sdp_offer}

MGS Get Media SDP Answer Message From Call
    [Documentation]    Gets sdp answer message from MGS call
    [Arguments]    ${call}
    ${sdp_answer}=    get media sdp answer from call mgs    ${call}
    Log    SDP answer message: ${sdp_answer}

    [Return]    ${sdp_answer}

MGS Get SDP Attribute Values
    [Documentation]    Retrieves sdp attribute values by attribute field from sdp message
    [Arguments]    ${sdp_message}    ${sdp_attribute_field}
    ${sdp_attribute_values}=    get sdp attribute values by attribute field mgs    ${sdp_message}    ${sdp_attribute_field}
    Log    SDP attribute values: ${sdp_attribute_values}

    [Return]    ${sdp_attribute_values}

MGS Terminate Call
    [Documentation]    Terminates (ends) call in MGS by call id
    [Arguments]    ${call_id}
    end call by call id mgs    ${call_id}

MGS Delete Call
    [Documentation]    Deletes call in MGS by call id
    [Arguments]    ${call_id}
    delete call by call id mgs    ${call_id}

MGS Terminate All Active Calls by Simulator Instance Id
     [Documentation]    Terminates (ends) all active calls in MGS by configuration id (simulator instance id)
     [Arguments]    ${mgs_configuration_id}
     end all active calls by configuration id mgs    ${mgs_configuration_id}

MGS Verify Call Terminated
    [Documentation]    Verify if call terminated (call status is ended) in MGS by call id
    [Arguments]    ${call_id}
    ${call_status}=    get call status by call id mgs    ${call_id}
    Log    Call status: ${call_status}
    ${result}=    Set Variable If    "${call_status}" == "${ended_call_status}"    ${True}    ${False}
    Should Be True    ${result}

    [Return]    ${result}

MGS Verify Call Started
    [Documentation]    Verify if call started (call status is active) in MGS by call id
    [Arguments]    ${call_id}
    ${call_status}=    get call status by call id mgs    ${call_id}
    Log    Call status: ${call_status}
    ${result}=    Set Variable If    "${call_status}" == "${active_call_status}"    ${True}    ${False}
    Should Be True    ${result}

    [Return]    ${result}

MGS Verify Call Proceeding
    [Documentation]    Verify if call in proceeding state in MGS by call id
    [Arguments]    ${call_id}
    ${call_status}=    get call status by call id mgs    ${call_id}
    Log    Call status: ${call_status}
    ${result}=    Set Variable If    "${call_status}" == "${proceeding_call_status}"    ${True}    ${False}
    Should Be True    ${result}

    [Return]    ${result}

MGS Create Router Nena E911 Call Profile Manual ANI Configuration Mode
    [Documentation]    Creates mgs call profile ROUTER NENA E911 type with specified name and configuration parameters in manual ani configuration mode
    [Arguments]    ${call_profile_name}    ${ani_manual_number}    ${routing_request_uri}    ${media_file_name}    ${transport_protocol}=${default_call_profile_transport_protocol}
    ...    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ${created_profile}=    create router nena e911 call profile mgs    name=${call_profile_name}    ani_configuration_mode=${call_profile_manual_ani_configuration_mode}
    ...    ani_manual_number=${ani_manual_number}    routing_request_uri=${routing_request_uri}    transport_protocol=${transport_protocol}
    ...    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}

MGS Create Router Nena E911 Call Profile Auto ANI Configuration Mode
    [Documentation]    Creates mgs call profile ROUTER NENA E911 type with specified name and configuration parameters in auto ani configuration mode
    [Arguments]    ${call_profile_name}    ${ani_auto_telephone_number_template}    ${ani_auto_min_range}    ${ani_auto_max_range}
    ...    ${routing_request_uri}    ${media_file_name}    ${transport_protocol}=${default_call_profile_transport_protocol}
    ...    ${ani_auto_configuration_mode}=${default_call_profile_ani_auto_configuration_mode}
    ...    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ${created_profile}=    create router nena e911 call profile mgs    name=${call_profile_name}    ani_configuration_mode=${call_profile_auto_ani_configuration_mode}
    ...    ani_auto_telephone_number_template=${ani_auto_telephone_number_template}    ani_auto_min_range=${ani_auto_min_range}
    ...    ani_auto_max_range=${ani_auto_max_range}    ani_auto_configuration_mode=${ani_auto_configuration_mode}
    ...    routing_request_uri=${routing_request_uri}    transport_protocol=${transport_protocol}
    ...    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}

MGS Create Router MSI CCRouter Call Profile Manual ANI Configuration Mode
    [Documentation]    Creates mgs call profile ROUTER MSI CCROUTER type with specified name and configuration parameters in manual ani configuration mode
    [Arguments]    ${call_profile_name}    ${ani_manual_number}    ${outbound_proxy_uri}    ${to_uri}    ${route_uri}    ${route_headers_list}
    ...    ${geolocation_header_value_list}    ${media_file_name}    ${call_info_header_provider_info}=${EMPTY}    ${call_info_header_service_info}=${EMPTY}
    ...    ${outbound_proxy_uri_enabled}=${False}    ${transport_protocol}=${default_call_profile_transport_protocol}    ${call_info_header_subscriber_info_enabled}=${False}
    ...    ${call_info_header_subscriber_info}=${EMPTY}    ${geolocation_header_format}=${default_call_profile_geolocation_header_format}
    ...    ${call_info_header_device_info_enabled}=${False}    ${call_info_header_device_info}=${EMPTY}    ${call_info_header_comment_enabled}=${False}
    ...    ${call_info_header_comment}=${EMPTY}    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ${created_profile}=    create router msi ccrouter call profile mgs    name=${call_profile_name}    ani_configuration_mode=${call_profile_manual_ani_configuration_mode}
    ...    ani_manual_number=${ani_manual_number}    outbound_proxy_uri_enabled=${outbound_proxy_uri_enabled}    outbound_proxy_uri=${outbound_proxy_uri}
    ...    to_uri=${to_uri}    route_uri=${route_uri}    route_headers_list=${route_headers_list}    transport_protocol=${transport_protocol}
    ...    geolocation_header_format=${geolocation_header_format}    geolocation_header_value_list=${geolocation_header_value_list}
    ...    call_info_header_provider_info=${call_info_header_provider_info}    call_info_header_service_info=${call_info_header_service_info}
    ...    call_info_header_subscriber_info_enabled=${call_info_header_subscriber_info_enabled}
    ...    call_info_header_subscriber_info=${call_info_header_subscriber_info}    call_info_header_device_info_enabled=${call_info_header_device_info_enabled}
    ...    call_info_header_device_info=${call_info_header_device_info}    call_info_header_comment_enabled=${call_info_header_comment_enabled}
    ...    call_info_header_comment=${call_info_header_comment}    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}

MGS Create Router MSI CCRouter Call Profile Auto ANI Configuration Mode
    [Documentation]    Creates mgs call profile ROUTER MSI CCROUTER type with specified name and configuration parameters in auto ani configuration mode
    [Arguments]    ${call_profile_name}    ${ani_auto_telephone_number_template}    ${ani_auto_min_range}    ${ani_auto_max_range}
    ...    ${outbound_proxy_uri}    ${to_uri}    ${route_uri}    ${route_headers_list}    ${geolocation_header_value_list}    ${media_file_name}
    ...    ${call_info_header_provider_info}=${EMPTY}    ${call_info_header_service_info}=${EMPTY}    ${ani_auto_configuration_mode}=${default_call_profile_ani_auto_configuration_mode}
    ...    ${outbound_proxy_uri_enabled}=${False}    ${transport_protocol}=${default_call_profile_transport_protocol}
    ...    ${call_info_header_subscriber_info_enabled}=${False}    ${call_info_header_subscriber_info}=${EMPTY}    ${geolocation_header_format}=${default_call_profile_geolocation_header_format}
    ...    ${call_info_header_device_info_enabled}=${False}    ${call_info_header_device_info}=${EMPTY}    ${call_info_header_comment_enabled}=${False}
    ...    ${call_info_header_comment}=${EMPTY}    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ${created_profile}=    create router msi ccrouter call profile mgs    name=${call_profile_name}    ani_configuration_mode=${call_profile_auto_ani_configuration_mode}
    ...    ani_auto_telephone_number_template=${ani_auto_telephone_number_template}    ani_auto_min_range=${ani_auto_min_range}
    ...    ani_auto_max_range=${ani_auto_max_range}    ani_auto_configuration_mode=${ani_auto_configuration_mode}
    ...    outbound_proxy_uri_enabled=${outbound_proxy_uri_enabled}    outbound_proxy_uri=${outbound_proxy_uri}
    ...    to_uri=${to_uri}    route_uri=${route_uri}    route_headers_list=${route_headers_list}    transport_protocol=${transport_protocol}
    ...    geolocation_header_format=${geolocation_header_format}    geolocation_header_value_list=${geolocation_header_value_list}
    ...    call_info_header_provider_info=${call_info_header_provider_info}    call_info_header_service_info=${call_info_header_service_info}
    ...    call_info_header_subscriber_info_enabled=${call_info_header_subscriber_info_enabled}
    ...    call_info_header_subscriber_info=${call_info_header_subscriber_info}    call_info_header_device_info_enabled=${call_info_header_device_info_enabled}
    ...    call_info_header_device_info=${call_info_header_device_info}    call_info_header_comment_enabled=${call_info_header_comment_enabled}
    ...    call_info_header_comment=${call_info_header_comment}    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}

MGS Create Osp Verizon Nyc Atis V2.5 Wireless Call Profile
    [Documentation]    Creates mgs call profile OSP VERIZON NYC ATIS V2.5 wireless type with specified name and configuration parameters
    [Arguments]    ${call_profile_name}    ${pseudo_ani_telephone_number_template}    ${callee_to_uri}    ${route_uri}    ${route_headers_list}
    ...    ${geolocation_header_value_list}    ${call_info_header_list}    ${media_file_name}    ${pseudo_ani_min_range}=0    ${pseudo_ani_max_range}=999    ${line_type}=${wireless_call_profile_line_type}
    ...    ${geolocation_header_format}=${default_call_profile_geolocation_header_format}    ${call_info_header_format}=${default_call_profile_geolocation_header_format}
    ...    ${transport_protocol}=${default_call_profile_transport_protocol}    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ...    ${wireless_pseudo_ani_number_mode}=${call_profile_manual_ani_configuration_mode}    ${callback_ani_telephone_number_template}=${EMPTY}    ${callback_ani_min_range}=0    ${callback_ani_max_range}=999
    ...    ${wireless_callback_ani_number_mode}=${call_profile_manual_ani_configuration_mode}
    ${created_profile}=    create osp verizon nyc atis v2 5 call profile mgs    name=${call_profile_name}    line_type=${line_type}
    ...    wireless_pseudo_ani_number_mode=${wireless_pseudo_ani_number_mode}        wireless_pseudo_ani_number_template=${pseudo_ani_telephone_number_template}
    ...    wireless_pseudo_ani_min_range=${pseudo_ani_min_range}    wireless_pseudo_ani_max_range= ${pseudo_ani_max_range}
    ...    wireless_callback_ani_number_mode=${wireless_callback_ani_number_mode}    wireless_callback_ani_number_template=${callback_ani_telephone_number_template}
    ...    wireless_callback_ani_min_range=${callback_ani_min_range}    wireless_callback_ani_max_range=${callback_ani_max_range}
    ...    callee_to_uri=${callee_to_uri}    route_uri=${route_uri}    route_headers_list=${route_headers_list}    geolocation_header_format=${geolocation_header_format}
    ...    geolocation_header_value_list=${geolocation_header_value_list}    call_info_header_format=${call_info_header_format}   call_info_header_list=${call_info_header_list}
    ...    transport_protocol=${transport_protocol}    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}

MGS Create Osp Verizon Nyc Atis V2.5 Wireline Call Profile
    [Documentation]    Creates mgs call profile OSP VERIZON NYC ATIS V2.5 wireline type with specified name and configuration parameters
    [Arguments]    ${call_profile_name}    ${wireline_ani_telephone_number_template}    ${callee_to_uri}    ${route_uri}    ${route_headers_list}
    ...    ${geolocation_header_value_list}    ${call_info_header_list}    ${media_file_name}    ${wireline_ani_number_mode}=${call_profile_manual_ani_configuration_mode}    ${wireline_ani_min_range}=0
    ...    ${wireline_ani_max_range}=999    ${line_type}=${wireline_call_profile_line_type}    ${geolocation_header_format}=${default_call_profile_geolocation_header_format}
    ...    ${call_info_header_format}=${default_call_profile_geolocation_header_format}    ${transport_protocol}=${default_call_profile_transport_protocol}
    ...    ${voice_enabled}=${default_call_profile_voice_enabled}    ${media_catalog_subtype}=${default_call_profile_media_catalog_subtype}
    ${created_profile}=    create osp verizon nyc atis v2 5 call profile mgs    name=${call_profile_name}    line_type=${line_type}
    ...    wireline_ani_number_mode=${wireline_ani_number_mode}        wireline_ani_number_template=${wireline_ani_telephone_number_template}
    ...    wireline_ani_min_range=${wireline_ani_min_range}     wireline_ani_max_range=${wireline_ani_max_range}
    ...    callee_to_uri=${callee_to_uri}    route_uri=${route_uri}    route_headers_list=${route_headers_list}    geolocation_header_format=${geolocation_header_format}
    ...    geolocation_header_value_list=${geolocation_header_value_list}    call_info_header_format=${call_info_header_format}    call_info_header_list=${call_info_header_list}
    ...    transport_protocol=${transport_protocol}    voice_enabled=${voice_enabled}    media_file_name=${media_file_name}    media_catalog_subtype=${media_catalog_subtype}
    Log    Created profile: ${created_profile}
    ${profile_id}=    get profile id from profile mgs    ${created_profile}
    Should Not Be Empty    ${profile_id}

    [Return]    ${created_profile}