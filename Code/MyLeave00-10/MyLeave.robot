*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn

*** Variable ***
${id_login}    test_it_roles
${id_name}    IT ROLE TESTING
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]


*** Keywords ***
Employee Login Unsuccess
    Input Text    username    ${id_login}
    Input Password    password    0000
    Click button    id=submit myBtn

Employee Login Success
    Input Text    username    ${id_login}
    Input Password    password    1234
    Click button    id=submit myBtn

Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=test_it_roles"]
    Title Should Be    My leave list
    
Click Add Leave
    Click button    addLeave
    Title Should Be    Add Leave

*** Test Case ***

TC-LEAVE-EMP-001 Login_Unsuccess
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Employee Login Unsuccess
    Capture Page Screenshot    1_loginUnsuccess.png
    Run Keyword If All Tests Passed     

TC-LEAVE-EMP-002 Login_Success
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Employee Login Success
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${id_login}
    Capture Page Screenshot    2_loginSuccess.png

TC-LEAVE-EMP-003 vacation leave
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 19-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[5]

    # select start date >>> 20-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    Should Be True    '${check_dateFrom}' == '19-08-2021' and '${check_dateTo}' == '20-08-2021'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-003
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-003'
    
    # Input & Check Reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    Capture Page Screenshot    3_addLeave.png

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    # อย่าลืมสลับคอมเม้นท์ ทำเผื่อไว้เช็คตอนที่ไม่ใช่เวลาปัจจุบัน
    # ${split}=    Remove String    ${check_submit_data}    ${currentDate}    14    :    ${space}
    # Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} 14:${split}'
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    :    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}:${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # Start date (Since)
    ${check_StartDate}=    Get Table Cell    ${table}    1    5
    ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'


TC-LEAVE-EMP-004 vacation from the previous year
    Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${id_name}
    
    # Select Type of leave >>> ลาพักร้อนที่เหลือจากปีก่อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[5]
    Radio Button Should Be Set To    leaveType    6
    
    # Select Duration
    # select start date >>> 25-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[4]

    # select start date >>> 25-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[4]

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    Should Be True    '${check_dateFrom}' == '25-08-2021' and '${check_dateTo}' == '25-08-2021'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # # Input & Check Description
    # Input Text    id=description    TC-LEAVE-003
    # ${check_description}=    Get Value    xpath=//*[@id="description"]
    # Should Be True    '${check_description}' == 'TC-LEAVE-003'
    
    # # Input & Check Reason
    # Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ
    # ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    # Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ'

    # # Check Approver
    # ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    # Should Be True    '${check_approver}' == 'HR Role Testing'

    # # Check Status
    # ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    # Should Be True    '${check_status}' == 'Wait for approve'
    
    # # Click Submit Button
    # Click Element    xpath=//*[@class="btn btn-sm blue-soft"]
    # Capture Page Screenshot    3_addLeave.png

    # Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    # Click MyLeave Button

    # # Check data from table

    # # Submit Date
    # ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    # ${currentTime}    Get Current Date    result_format=%H
    # ${check_submit}=    Get Table Cell    ${table}    1    2
    # ${check_submit_data}=    Get Table Cell    ${table}    2    2
    # # อย่าลืมสลับคอมเม้นท์ ทำเผื่อไว้เช็คตอนที่ไม่ใช่เวลาปัจจุบัน
    # # ${split}=    Remove String    ${check_submit_data}    ${currentDate}    14    :    ${space}
    # # Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} 14:${split}'
    # ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    :    ${space}
    # Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}:${split}'

    # # The applicant
    # ${check_applicant}=    Get Table Cell    ${table}    1    3
    # ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    # Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # # Type of leave
    # ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    # ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    # Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลากิจ/ลาพักร้อน'

    # # Start date (Since)
    # ${check_StartDate}=    Get Table Cell    ${table}    1    5
    # ${check_StartDate_data}=    Get Table Cell    ${table}    2    5
    # Should Be True    '${check_StartDate}' == 'Start date (Since)' and '${check_StartDate_data}' == '${check_dateFrom}'

    # # End date (Until)
    # ${check_EndDate}=    Get Table Cell    ${table}    1    6
    # ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    # Should Be True    '${check_EndDate}' == 'End date (Until)' and '${check_EndDate_data}' == '${check_dateTo}'

    # # Amount the day
    # ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    # ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    # Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # # Status
    # ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    # ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    # Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    # Close Browser


