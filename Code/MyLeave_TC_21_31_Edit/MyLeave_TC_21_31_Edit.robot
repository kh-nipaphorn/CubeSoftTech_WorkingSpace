*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn

*** Variable ***
${it_login}    test_it_roles
${hr_login}    test_hr_role
${hr_name}    HR Role Testing
${it_name}    IT ROLE TESTING
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]

${drag}    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div[2]/div/div/div[2]/div/div[1]/div/div[2]/div/table/tbody/tr/td/div/div/div[2]/div[2]/table/tbody/tr/td[2]
${drop}    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div[2]/div/div/div[2]/div/div[1]/div/div[2]/div/table/tbody/tr/td/div/div/div[2]/div[2]/table/tbody/tr/td[3]


*** Keywords ***
Employee Login Success
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${it_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${it_login}
    Sleep    5s
Employee Login Success2
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${it_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${it_login}
    Sleep    5s

HR Login Success
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${hr_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    Page Should Contain    ${hr_login}
    Sleep    5s

IT Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=test_it_roles"]
    Title Should Be    My leave list

HR Click MyLeave Button
    Click Element    xpath://*[@href="myleave_list?Id=test_hr_role"]
    Title Should Be    My leave list
    
Click Add Leave
    Click button    addLeave
    Title Should Be    Add Leave

Click For Log Out
    # Click Element    xpath=/html/body/div[1]/div/div[3]/div/ul/li/a
    Click Element    xpath://*[@class="username username-hide-on-mobile"]
    # Click Element    xpath://*[@href="javascript:;"]
    Click Element    xpath://*[@href="logout"]
    Wait Until Page Contains    Login to your account
HR Click Leave Approve
    Click Element    xpath://*[@href="leave_approved"]
    title Should Be    Leave approved

*** Test Case ***

Login_Success
    Employee Login Success
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-021 P_Edit_Type_Of_Leave
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
    # Select Duration
    # select start date >>> 19-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[5]    # select date

    # select end date >>> 20-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '19-08-''${year}' and '${check_dateTo}' == '20-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-021
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-021'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

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

    Sleep    10s
    Capture Page Screenshot    21_1_Before_Edit_Type_Of_Leave.png

    #------------------------------------ Edit Part -------------------------------------#
    
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]
    
    # Change Type of leave >>> ลากิจ ลาพักร้อน -> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    # Check data from table

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

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

    Sleep    10s
    Capture Page Screenshot    21_2_After_Edit_Type_Of_Leave.png
    Log to Console  This Test Case Is Pass

TC-LEAVE-EMP-022 P_Edit_Duration_Of_Leave
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาป่วย
    Click Element    xpath=//*[@id="leaveTypes"]/label[3]
    Radio Button Should Be Set To    leaveType    3
    
    # Select Duration
    # select start date >>> 27-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[6]    # select date

    # select end date >>> 27-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[6]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '27-08-''${year}' and '${check_dateTo}' == '27-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-022
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-022'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาป่วย'

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

    Sleep    10s
    Capture Page Screenshot    22_1_Before_Edit_Duration_Of_Leave.png

    #------------------------------------ Edit Part -------------------------------------#
    
    IT Click MyLeave Button

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Select Duration
    # select start date >>> 20-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]    # select date

    # select start date >>> 20-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[6]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '20-08-''${year}' and '${check_dateTo}' == '20-08-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    # Check data from table

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

    Sleep    10s
    Capture Page Screenshot    22_2_After_Edit_Duration_Of_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-023 P_Edit_Description_Of_Leave
    Employee Login Success
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 01-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]   # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # select date

    # select end date >>> 01-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]   # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '01-09-''${year}' and '${check_dateTo}' == '01-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-020
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-020'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

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

    Sleep    10s
    Capture Page Screenshot    23_1_Before_Edit_Description_Of_Leave.png

    #----------------------------- Edit Part ------------------------------------------------#

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Description
    Clear Element Text    id=description
    Input Text    id=description    TC-LEAVE-023
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-023'

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

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

    Sleep    10s
    Capture Page Screenshot    23_2_After_Edit_Description_Of_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-024 P_Edit_Reason_Of_Leave

    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาโดยไม่รับค่าจ้าง
    Click Element    xpath=//*[@id="leaveTypes"]/label[4]
    Radio Button Should Be Set To    leaveType    5
    
    # Select Duration
    # select start date >>> 02-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '3'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-024
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-024'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาโดยไม่รับค่าจ้าง'

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

    Sleep    10s
    Capture Page Screenshot    24_1_Before_Edit_Reason_Of_Leave.png

    #---------------------------------- Edit Part -----------------------------#

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Reason
    Clear Element Text    id=reason
    Input Text    id=reason    เป็นส่วนหนึ่งในการทดสอบ LEAVE-024
    ${check_reason}=    Get Value    xpath=//*[@id="reason"]
    Should Be True    '${check_reason}' == 'เป็นส่วนหนึ่งในการทดสอบ LEAVE-024'

    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาโดยไม่รับค่าจ้าง'

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

    Sleep    10s
    Capture Page Screenshot    24_2_After_Edit_Reason_Of_Leave.png

TC-LEAVE-EMP-025 P_Edit_Half_Of_Day_Leave_And_Hour
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>>  03-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select this for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[6]    # select date

    # select end date >>>  06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select this for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '03-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '2'

    # Input & Check Hours
    Click Element    xpath=//*[@id="amount_sub"]
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[4]
    ${check_hour}    Get Text    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[4]
    Should Be True    '${check_hour}' == '3'
    ${check_hour_value}=    Get Value    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[4]
    ${split_value}=    Remove String    ${check_hour_value}    0

    # input & check half of day leave
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[1]   # Morning
    # Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[1]   # Afternoon
    Radio Button Should Be Set To    halfDay    1

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-025
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-025'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

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
    # ${split}=    Remove String    ${check_AmountOfTheDay_data}    ${check_amount}
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}${split_value}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    25_1_Before_Edit_Half_Of_Day_Leave.png

    # ---------------------------------------- Edit Part -----------------------------------#

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Hours
    Click Element    xpath=//*[@id="amount_sub"]
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[6]
    ${check_hour}    Get Text    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[6]
    Should Be True    '${check_hour}' == '5'
    ${check_hour_value}=    Get Value    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[3]/div[2]/select/option[6]
    ${split_value}=    Remove String    ${check_hour_value}    0

    # input & check half of day leave
    # Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[1]   # Morning
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[4]/div/div/label[2]   # Afternoon
    Radio Button Should Be Set To    halfDay    2

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาอื่นๆ'

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
    # ${split}=    Remove String    ${check_AmountOfTheDay_data}    ${check_amount}
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}${split_value}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    10s
    Capture Page Screenshot    25_2_After_Edit_Half_Of_Day_Leave.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-026 N_Edit_Description_Approve
    
    # ------------------------------------Add Leave-------------------------------------------------#
    
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาโดยไม่รับค่าจ้าง
    Click Element    xpath=//*[@id="leaveTypes"]/label[4]
    Radio Button Should Be Set To    leaveType    5
    
    # Select Duration
    # select start date >>> 02-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '3'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-026
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-026'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาโดยไม่รับค่าจ้าง'

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

    Sleep    10s
    Capture Page Screenshot    26_1_Add_Leave_WaitingForApprove.png

    Click For Log Out

    # ---------------------------------------- Hr Approve Part --------------------------------------------#

    HR Login Success
    HR Click Leave Approve
    
    # Select Duration
    # select start date >>> 02-09-2021
    # search date
    Click Element    id=startdate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=enddate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date


    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Approve
    Click Element    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    # Approve
    Click Element    xpath=//*[@onclick="ajaxLoad(${check_LeaveS_ID_data})"]
    
    Sleep    5s
    Capture Page Screenshot    26_2_HR_Approve.png
    Reload Page
    Sleep    5s
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Approved'

    Click For Log Out

    #----------------------------------- Edit Part --------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Approved'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Description
    Clear Element Text    id=description
    Input Text    id=description    TC-LEAVE-026 Edit
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-026 Edit'

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    ${check_LeaveS_ID_data3}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data3}'

    # The applicant
    ${check_applicant_data2}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant_data}' == '${check_applicant_data2}'

    # Type of leave
    ${check_typeOfLeave_data2}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave_data}' == '${check_typeOfLeave_data2}'

    # Start date (Since)
    ${check_StartDate_data2}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate_data2}' == '${check_StartDate_data}'

    # End date (Until)
    ${check_EndDate_data2}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate_data}' == '${check_EndDate_data2}'

    # Amount the day
    ${check_AmountOfTheDay_data2}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay_data}' == '${check_AmountOfTheDay_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Approved'

    Sleep    5s
    Capture Page Screenshot    26_3_After_Edit_Description_When_HR_Approved.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-027 P_Edit_Description_Approve 
    # ------------------------------------Add Leave-------------------------------------------------#
    
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลาโดยไม่รับค่าจ้าง
    Click Element    xpath=//*[@id="leaveTypes"]/label[4]
    Radio Button Should Be Set To    leaveType    5
    
    # Select Duration
    # select start date >>> 02-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-09-''${year}' and '${check_dateTo}' == '06-09-''${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '3'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-027
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-027'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

    # The applicant
    ${check_applicant}=    Get Table Cell    ${table}    1    3
    ${check_applicant_data}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant}' == 'The applicant' and '${check_applicant_data}' == 'test_it_roles'

    # Type of leave
    ${check_typeOfLeave}=    Get Table Cell    ${table}    1    4
    ${check_typeOfLeave_data}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave}' == 'Type of leave' and '${check_typeOfLeave_data}' == 'ลาโดยไม่รับค่าจ้าง'

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

    Sleep    10s
    Capture Page Screenshot    27_1_Add_Leave_WaitingForApprove.png

    Click For Log Out

    # ---------------------------------------- Hr Approve Part --------------------------------------------#

    HR Login Success
    HR Click Leave Approve

    # select start date >>> 02-09-2021
    # search date
    Click Element    id=startdate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # select end date >>> 06-09-2021
    Click Element   id=enddate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date
    
    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Approve
    Click Element    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    # Approve
    Click Element    xpath=//*[@onclick="ajaxLoad(${check_LeaveS_ID_data})"]
    
    Sleep    5s
    Capture Page Screenshot    27_2_HR_Approve.png
    Reload Page
    Sleep    5s
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Approved'
    Sleep    5s

    Click For Log Out

    #----------------------------------- Edit Part --------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Approved'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Description 
    Clear Element Text    id=description
    Input Text    id=description    TC-LEAVE-027 Edit
    ${check_description2}=    Get Value    xpath=//*[@id="description"]
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_description2}' != 'TC-LEAVE-027 Edit'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!


    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    ${check_LeaveS_ID_data3}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data3}'

    # The applicant
    ${check_applicant_data2}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant_data}' == '${check_applicant_data2}'

    # Type of leave
    ${check_typeOfLeave_data2}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave_data}' == '${check_typeOfLeave_data2}'

    # Start date (Since)
    ${check_StartDate_data2}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate_data2}' == '${check_StartDate_data}'

    # End date (Until)
    ${check_EndDate_data2}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate_data}' == '${check_EndDate_data2}'

    # Amount the day
    ${check_AmountOfTheDay_data2}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay_data}' == '${check_AmountOfTheDay_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Approved'

    Sleep    5s
    Capture Page Screenshot    27_3_After_Edit_Description_When_HR_Approved.png
    Log To Console    This Test Case Is ${Fail}

TC-LEAVE-EMP-028 N_Edit_Description_Reject
    
    # ------------------------------------Add Leave-------------------------------------------------#
    
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
   # Select Duration
    # select start date >>> 02-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 02-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-08-${year}' and '${check_dateTo}' == '02-08-${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-028
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-028'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

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

    Sleep    10s
    Capture Page Screenshot    28_1_Add_Leave_WaitingForApprove.png

    Click For Log Out

    # ---------------------------------------- Hr Reject Part --------------------------------------------#

    HR Login Success
    HR Click Leave Approve

    # search date
     # select start date >>> 02-08-2021
    Click Element    id=startdate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 02-08-2021
    Click Element    id=enddate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]
    
    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Approve
    Click Element    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    # Reject
    Click Element    xpath=//*[@onclick="call_reject_popup(${check_LeaveS_ID_data});"]
    Sleep    5s
    Click Element    xpath=//*[@onclick="beforeRejectAction();"]
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="app0-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Reject'
    
    Sleep    5s
    Capture Page Screenshot    28_2_HR_Reject.png
    Reload Page
    Sleep    5s

    Click For Log Out

    #----------------------------------- Edit Part --------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Reject'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Description
    Clear Element Text    id=description
    Input Text    id=description    TC-LEAVE-028 Edit
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-028 Edit'

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    ${check_LeaveS_ID_data3}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data3}'

    # The applicant
    ${check_applicant_data2}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant_data}' == '${check_applicant_data2}'

    # Type of leave
    ${check_typeOfLeave_data2}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave_data}' == '${check_typeOfLeave_data2}'

    # Start date (Since)
    ${check_StartDate_data2}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate_data2}' == '${check_StartDate_data}'

    # End date (Until)
    ${check_EndDate_data2}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate_data}' == '${check_EndDate_data2}'

    # Amount the day
    ${check_AmountOfTheDay_data2}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay_data}' == '${check_AmountOfTheDay_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Reject'

    Sleep    5s
    Capture Page Screenshot    28_3_After_Edit_Description_When_HR_Reject.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-029 P_Edit_Description_Reject

    # ------------------------------------Add Leave-------------------------------------------------#
    
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
   # Select Duration
    # select start date >>> 02-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 02-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '02-08-${year}' and '${check_dateTo}' == '02-08-${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-029
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-029'
    
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

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

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

    Sleep    10s
    Capture Page Screenshot    29_1_Add_Leave_WaitingForApprove.png

    Click For Log Out

    # ---------------------------------------- Hr Reject Part --------------------------------------------#

    HR Login Success
    HR Click Leave Approve

    # search date
     # select start date >>> 02-08-2021
    Click Element    id=startdate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 02-08-2021
    Click Element    id=enddate
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]
    
    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Approve
    Click Element    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    # Reject
    Click Element    xpath=//*[@onclick="call_reject_popup(${check_LeaveS_ID_data});"]
    Sleep    5s
    Click Element    xpath=//*[@onclick="beforeRejectAction();"]
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="app0-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Reject'
    
    Sleep    5s
    Capture Page Screenshot    29_2_HR_Reject.png
    Reload Page
    Sleep    5s

    Click For Log Out

    #----------------------------------- Edit Part --------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Reject'

    Click Element    xpath=//*[@href="LeaveEdit?id=${check_LeaveS_ID_data}"]

    # Input & Check Description 
    Clear Element Text    id=description
    Input Text    id=description    TC-LEAVE-029 Edit
    ${check_description2}=    Get Value    xpath=//*[@id="description"]
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_description2}' != 'TC-LEAVE-029 Edit'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leave_list
    IT Click MyLeave Button

    ${check_LeaveS_ID_data3}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data3}'

    # The applicant
    ${check_applicant_data2}=    Get Table Cell    ${table}    2    3
    Should Be True    '${check_applicant_data}' == '${check_applicant_data2}'

    # Type of leave
    ${check_typeOfLeave_data2}=    Get Table Cell    ${table}    2    4
    Should Be True    '${check_typeOfLeave_data}' == '${check_typeOfLeave_data2}'

    # Start date (Since)
    ${check_StartDate_data2}=    Get Table Cell    ${table}    2    5
    Should Be True    '${check_StartDate_data2}' == '${check_StartDate_data}'

    # End date (Until)
    ${check_EndDate_data2}=    Get Table Cell    ${table}    2    6
    Should Be True    '${check_EndDate_data}' == '${check_EndDate_data2}'

    # Amount the day
    ${check_AmountOfTheDay_data2}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay_data}' == '${check_AmountOfTheDay_data2}'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Reject'

    Sleep    5s
    Capture Page Screenshot    29_3_After_Edit_Description_When_HR_Reject.png
    Log To Console    This Test Case Is ${Fail}

TC-LEAVE-EMP-030 N_Drag_Drop_Leave_Button_In_CalenderPage
    # ------------------------------------Add Leave-------------------------------------------------#
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
   # Select Duration
    # select start date >>> 06-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '06-09-${year}' and '${check_dateTo}' == '06-09-${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

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

    Sleep    5s
    Capture Page Screenshot    30_1_Add_Leave.png

    #--------------------------drag and drop -----------------------------------#
    
    # Click Calendar Button
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/a
    # Click Check All Calendar
    Click Element    xpath=//*[@href="check_allCalendar"]
    Title Should be    Check All Calendar
    Sleep    5s

    Capture Page Screenshot    30_2_Before_DragAndDrop.png
    Drag And drop    ${drag}    ${drop}
    Capture Page Screenshot    30_3_After_DragAndDrop.png

    IT Click MyLeave Button

    # Check data from table
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'


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
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_StartDate_data}' == '07-09-''${year}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_EndDate_data}' == '07-09-''${year}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    30_4_CheckData_DragAndDrop.png
    Log To Console    This Test Case Is ${Fail}

TC-LEAVE-EMP-031 P_Drag_Drop_Leave_Button_In_CalenderPage
    # ------------------------------------Add Leave-------------------------------------------------#
    Employee Login Success
    IT Click MyLeave Button
    Click Add Leave

    Wait Until Page Contains    ${it_name}
    
    # Select Type of leave >>> ลากิจ ลาพักร้อน
    Click Element    xpath=//*[@id="leaveTypes"]/label[1]
    Radio Button Should Be Set To    leaveType    1
    
   # Select Duration
    # select start date >>> 06-09-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select end date >>> 06-09-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Check Duration
    ${check_dateFrom}=    Get Value    xpath=//*[@id="date_from"]
    ${check_dateTo}=    Get Value    xpath=//*[@id="date_to"]
    ${year}    Get Current Date    result_format=%Y
    Should Be True    '${check_dateFrom}' == '06-09-${year}' and '${check_dateTo}' == '06-09-${year}'

    # Check amount
    ${check_amount}=    Get Value    xpath=//*[@id="amount"]
    Should Be True    '${check_amount}' == '1'

    # Check Approver
    ${check_approver}=    Get Text    xpath=//*[@id="select2-approver-container"]
    Should Be True    '${check_approver}' == 'HR Role Testing'

    # Check Status
    ${check_status}=    Get Text    xpath=//*[@id="status"]/option[1]
    Should Be True    '${check_status}' == 'Wait for approve'
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Submit Date
    ${currentDate}    Get Current Date    result_format=%d-%m-%Y
    ${currentTime}    Get Current Date    result_format=%H:
    ${check_submit}=    Get Table Cell    ${table}    1    2
    ${check_submit_data}=    Get Table Cell    ${table}    2    2
    ${split}=    Remove String    ${check_submit_data}    ${currentDate}    ${currentTime}    ${space}
    Should Be True    '${check_submit}' == 'Submit date' and '${check_submit_data}' == '${currentDate} ${currentTime}${split}'

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

    Sleep    5s
    Capture Page Screenshot    31_1_Add_Leave.png

    #--------------------------drag and drop -----------------------------------#
    
    # Click Calendar Button
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[2]/a
    # Click Check All Calendar
    Click Element    xpath=//*[@href="check_allCalendar"]
    Title Should be    Check All Calendar
    Sleep    5s

    Capture Page Screenshot    31_2_Before_DragAndDrop.png
    Drag And drop    ${drag}    ${drop}
    Capture Page Screenshot    31_3_After_DragAndDrop.png

    IT Click MyLeave Button

    # Check data from table
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'


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
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_StartDate_data}' != '07-09-''${year}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # End date (Until)
    ${check_EndDate}=    Get Table Cell    ${table}    1    6
    ${check_EndDate_data}=    Get Table Cell    ${table}    2    6
    ${Fail}=    Run Keyword And Return Status    Should Be True    '${check_EndDate_data}' != '07-09-''${year}'
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

    # Amount the day
    ${check_AmountOfTheDay}=    Get Table Cell    ${table}    1    7
    ${check_AmountOfTheDay_data}=    Get Table Cell    ${table}    2    7
    Should Be True    '${check_AmountOfTheDay}' == 'Amount the day' and '${check_AmountOfTheDay_data}' == '${check_amount}.000'

    # Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    31_4_CheckData_DragAndDrop.png
    Log To Console    This Test Case Is Pass

    Close All Browsers