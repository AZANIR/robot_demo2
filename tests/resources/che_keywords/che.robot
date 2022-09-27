*** Settings ***
Documentation   Keywords for querying CHE API.
Library    Collections
Library    ../../../helpers/che/che.py


*** Variables ***
${created_call_status}   CREATED
${regenerating_call_status}    RENEGOTIATING
${proceeding_call_status}   PROCEEDING
${ringing_call_status}    RINGING
${cancelled_call_status}   CANCELLED
${ending_call_status}     ENDING
${redirecting_call_status}    REDIRECTING
${ended_call_status}    ENDED
${failed_call_status}    FAILED
${active_call_status}    ACTIVE

*** Keywords ***
CHE Get All Calls
    [Documentation]    Get all call from CHE
    ${all_calls}=    get_all_calls_che
    Log    Active calls: ${all_calls}

    [Return]    ${all_calls}


CHE Verify Call Started
    [Documentation]    Verify if call started (call status is ACTIVE) in CHE by call id
    [Arguments]    ${call_id}
    ${call_status}=    get_call_status_by_call_id_che    ${call_id}
    Log    Call status: ${call_status}
    ${result}=    Set Variable If    "${call_status}" == "${active_call_status}"    ${True}    ${False}
    Should Be True    ${result}

    [Return]    ${result}


CHE Get Call Status
    [Documentation]    Get call status from CHE by call id
    [Arguments]    ${call_id}
    ${call_status}=    get_call_status_by_call_id_che    ${call_id}
    Log    Call status (state): ${call_status}
    Should Not Be Empty    ${call_status}

    [Return]    ${call_status}


CHE Terminate Call
    [Documentation]    Verify if call terminated (call status is ENDED) in CHE by call id
    [Arguments]    ${call_id}
    end call with id che    ${call_id}


CHE Verify Call Terminated
    [Documentation]    Verify if call terminated (call status is ENDED) in CHE by call id
    [Arguments]    ${call_id}
    ${call_status}=    get_call_status_by_call_id_che    ${call_id}
    Log    Call status: ${call_status}
    ${result}=    Set Variable If    "${call_status}" == "${ended_call_status}"    ${True}    ${False}
    Should Be True    ${result}

    [Return]    ${result}


CHE Terminate All Active Calls
     [Documentation]    Terminates (ends) all active calls in CHE
     end all active calls che


CHE Pickup Call
    [Documentation]    Picks up call with id from CHE
    [Arguments]    ${call_id}
    pickup call with id che    ${call_id}


CHE Update Call Handling Profile
    [Documentation]    Update call handling profile (enable or disable call auto pick up, media)
    [Arguments]    ${auto_pickup}    ${media_enabled}
    update call handling profile che    ${auto_pickup}    ${media_enabled}


CHE Get Call originalInvitee
    [Documentation]    Get call originalInvitee from CHE by call id
    [Arguments]    ${call_id}
    ${call_originalInvitee}=    get_call_original_invite_by_call_id_che    ${call_id}
    Log    Call originalInvitee: ${call_originalInvitee}
    Should Not Be Empty    ${call_originalInvitee}

    [Return]    ${call_originalInvitee}


CHE Get Call Location
    [Documentation]    Get call location from CHE by call id
    [Arguments]    ${call_id}
    ${call_location}=    get_call_location_by_call_id_che    ${call_id}
    Log    Call location: ${call_location}
    Should Not Be Empty    ${call_location}

    [Return]    ${call_location}


CHE Get Call Position
    [Documentation]    Get call position from CHE by call id
    [Arguments]    ${call_id}
    ${call_position}=    get call position by call id che    ${call_id}
    Log    Call position: ${call_position}
    Should Not Be Empty    ${call_position}

    [Return]    ${call_position}


CHE Get Call Phone
    [Documentation]    Get call phone from CHE by call id
    [Arguments]    ${call_id}
    ${call_phone}=    get call phone by call id che    ${call_id}
    Log    Call phone: ${call_phone}
    Should Not Be Empty    ${call_phone}

    [Return]    ${call_phone}


CHE Get Call Current Session Media Info
    [Documentation]    Get call current session media info from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info}=    get_call_media_session_info_by_call_id_che    ${call_id}
    Log    Call current session media info: ${call_current_session_media_info}
    Should Not Be Empty    ${call_current_session_media_info}

    [Return]    ${call_current_session_media_info}


CHE Get Call Handling Parameters Media Enabled
    [Documentation]    Get call handling parameters media enabled from CHE by call id
    [Arguments]    ${call_id}
    ${call_handling_parameters_media_enabled}=    get_call_media_enabled_by_call_id_che    ${call_id}
    Log    Call handling parameters media enabled: ${call_handling_parameters_media_enabled}
    Should Not Be Empty    ${call_handling_parameters_media_enabled}

    [Return]    ${call_handling_parameters_media_enabled}


CHE Get Call Handling Parameters Media Endpoint Id
    [Documentation]    Get call handling parameters media endpoint id from CHE by call id
    [Arguments]    ${call_id}
    ${call_handling_parameters_media_endpoint_id}=    get_call_handling_parameters_media_endpoint_id_by_call_id_che    ${call_id}
    Log    Call handling parameters media endpoint id: ${call_handling_parameters_media_endpoint_id}
    Should Not Be Empty    ${call_handling_parameters_media_endpoint_id}

    [Return]    ${call_handling_parameters_media_endpoint_id}


CHE Get Call Current Session Media Info Id
    [Documentation]    Get call current session media info id from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info_id}=    get_call_current_media_session_id_by_call_id_che    ${call_id}
    Log    Call current session media info id: ${call_current_session_media_info_id}
    Should Not Be Empty    ${call_current_session_media_info_id}

    [Return]    ${call_current_session_media_info_id}


CHE Get Call Current Session Media Info Endpoint Id
    [Documentation]    Get call current session media info endpoint id from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info_endpoint_id}=    get_call_current_session_media_endpoint_id_by_call_id_che    ${call_id}
    Log    Call current session media info endpoint id: ${call_current_session_media_info_endpoint_id}
    Should Not Be Empty    ${call_current_session_media_info_endpoint_id}

    [Return]    ${call_current_session_media_info_endpoint_id}


CHE Get Call Current Session Media Info Rtp Element Id
    [Documentation]    Get call current session media info rtp element id from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info_rtp_element_id}=    get_call_current_media_session_rtp_element_id_by_call_id_che    ${call_id}
    Log    Call current session media info rtp element id: ${call_current_session_media_info_rtp_element_id}
    Should Not Be Empty    ${call_current_session_media_info_rtp_element_id}

    [Return]    ${call_current_session_media_info_rtp_element_id}


CHE Get Call Current Session Media Info Sdp Offer
    [Documentation]    Get call current session media info sdp offer from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info_sdp_offer}=    get_call_current_media_session_sdp_offer_by_call_id_che    ${call_id}
    Log    Call current session media info sdp offer: ${call_current_session_media_info_sdp_offer}
    Should Not Be Empty    ${call_current_session_media_info_sdp_offer}

    [Return]    ${call_current_session_media_info_sdp_offer}


CHE Get Call Current Session Media Info Sdp Answer
    [Documentation]    Get call current session media info sdp answer from CHE by call id
    [Arguments]    ${call_id}
    ${call_current_session_media_info_sdp_answer}=    get_call_current_media_session_sdp_answer_by_call_id_che    ${call_id}
    Log    Call current session media info sdp answer: ${call_current_session_media_info_sdp_answer}
    Should Not Be Empty    ${call_current_session_media_info_sdp_answer}

    [Return]    ${call_current_session_media_info_sdp_answer}


CHE Get SDP Attribute Values
    [Documentation]    Retrieves sdp attribute values by attribute field from sdp message
    [Arguments]    ${sdp_message}    ${sdp_attribute_field}
    ${sdp_attribute_values}=    get_sdp_attribute_values_by_attribute_field_che    ${sdp_message}    ${sdp_attribute_field}
    Log    SDP attribute values: ${sdp_attribute_values}

    [Return]    ${sdp_attribute_values}


CHE Get Call Target Uri
    [Documentation]    Get call target uri from CHE by call id
    [Arguments]    ${call_id}
    ${call_target_uri}=    get_call_target_uri_by_call_id_che    ${call_id}
    Log    Call target uri: ${call_target_uri}
    Should Not Be Empty    ${call_target_uri}

    [Return]    ${call_target_uri}


CHE Get Call Transport Protocol
    [Documentation]    Get call transport protocol from CHE by call id
    [Arguments]    ${call_id}
    ${call_transport_protocol}=    get_call_transport_protocol_by_call_id_che    ${call_id}
    Log    Call transport protocol: ${call_transport_protocol}
    should not be empty    ${call_transport_protocol}

    [Return]    ${call_transport_protocol}


CHE Get Call Info Local Tag
    [Documentation]    Get call info local tag from CHE by call id
    [Arguments]    ${call_id}
    ${call_info_local_tag}=    get_call_info_local_tag_by_call_id_che    ${call_id}
    Log    Call info local tag: ${call_info_local_tag}
    Should Not Be Empty    ${call_info_local_tag}

    [Return]    ${call_info_local_tag}


CHE Get Call Info Remote Tag
    [Documentation]    Get call info remote tag from CHE by call id
    [Arguments]    ${call_id}
    ${call_info_remote_tag}=    get_call_info_remote_tag_by_call_id_che    ${call_id}
    Log    Call info remote tag: ${call_info_remote_tag}
    Should Not Be Empty    ${call_info_remote_tag}

    [Return]    ${call_info_remote_tag}


CHE Get Call Error Message
    [Documentation]    Get call error message from CHE by call id
    [Arguments]    ${call_id}
    ${call_error_message}=    get_call_error_message_by_call_id_che    ${call_id}
    Log    Call error message: ${call_error_message}

    [Return]    ${call_error_message}


CHE Get Call Original Invite
    [Documentation]    Get call original invite from CHE by call id
    [Arguments]    ${call_id}
    ${call_original_invite}=    get_call_original_invite_by_call_id_che    ${call_id}
    Log    Call original invite: ${call_original_invite}
    Should Not Be Empty    ${call_original_invite}

    [Return]    ${call_original_invite}


CHE Get Call Previous Session Media Info Id
    [Documentation]    Get call previous session media info id from CHE by call id
    [Arguments]    ${call_id}
    ${call_previous_session_media_info_id}=    get_call_previous_media_session_info_by_call_id_che    ${call_id}
    Log    Call previous session media info id: ${call_previous_session_media_info_id}
    Should Not Be Empty    ${call_previous_session_media_info_id}

    [Return]    ${call_previous_session_media_info_id}


CHE Get Call Sip Endpoint Id
    [Documentation]    Get call sip endpoint id from CHE by call id
    [Arguments]    ${call_id}
    ${call_sip_endpoint_id}=    get_call_sip_endpoint_id_by_call_id_che    ${call_id}
    Log    Call sip endpoint id: ${call_sip_endpoint_id}
    Should Not Be Empty    ${call_sip_endpoint_id}

    [Return]    ${call_sip_endpoint_id}


CHE Get Call Handling Parameters
    [Documentation]    Get call handling parameters from CHE by call id
    [Arguments]    ${call_id}
    ${call_handling_parameters}=    get_call_handling_parameters_by_call_id_che    ${call_id}
    Log    Call handling parameters: ${call_handling_parameters}
    Should Not Be Empty    ${call_handling_parameters}

    [Return]    ${call_handling_parameters}


CHE Get Call Handling Parameters Auto Pickup
    [Documentation]    Get call handling parameters auto pickup from CHE by call id
    [Arguments]    ${call_id}
    ${call_handling_parameters_auto_pickup}=    get_call_handling_parameters_auto_pickup_by_call_id_che    ${call_id}
    Log    Call handling parameters auto pickup: ${call_handling_parameters_auto_pickup}
    Should Not Be Empty    ${call_handling_parameters_auto_pickup}

    [Return]    ${call_handling_parameters_auto_pickup}
