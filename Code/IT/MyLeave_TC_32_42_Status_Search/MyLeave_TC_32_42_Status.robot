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
${table_body}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr
${Duration_datefrom}    xpath=//*[@id="date_from"]
${Duration_dateto}    xpath=//*[@id="date_to"]



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
    Click Element    xpath://*[@class="username username-hide-on-mobile"]
    Click Element    xpath://*[@href="logout"]
    Wait Until Page Contains    Login to your account
HR Click Leave Approve
    Click Element    xpath://*[@href="leave_approved"]
    title Should Be    Leave approved

*** Test Case ***

Login_Success
    Employee Login Success
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-032 P_Find_MyLeave_WaitingForApprove
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


    # Input & Check Description
    Input Text    id=description    TC-LEAVE-032
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-032'
    
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Check Leave ID
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Check Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    32_1_MyLeave_WaitingForApprove.png
    Log To Console    This Test Case Is Pass

TC-LEAVE-EMP-033 P_Find_MyLeave_Approve
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


    # Input & Check Description
    Input Text    id=description    TC-LEAVE-033
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-033'
    
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Check Leave ID
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Check Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    33_1_MyLeave_WaitingForApprove.png
    Sleep    5s
    
    # Logout
    Click For Log Out

    # -------------------------------- Hr Approve Part -------------------------------------------#
    
    HR Login Success
    HR Click Leave Approve

    # search date
    # select start date >>> 02-09-2021
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
    Capture Page Screenshot    33_2_HR_Approve.png
    Reload Page
    Sleep    5s
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Approved'
    Sleep    5s

    Click For Log Out

    # ----------------------------- Find MyLeave ----------------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    # Check Leave ID
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Check Status
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Approved'
    
    Sleep    5s
    Capture Page Screenshot    33_3_MyLeave_Approved.png
    Sleep    5s

TC-LEAVE-EMP-034 P_Find_MyLeave_Reject
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

    # select start date >>> 02-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-034
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-034'
    
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Check Leave ID
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Check Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    34_1_MyLeave_WaitingForApprove.png
    Sleep    5s
    
    # Logout
    Click For Log Out

    # -------------------------------- Hr Reject Part -------------------------------------------#
    
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
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    
    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Reject
    Click Element    xpath=//*[@class="wait-${check_LeaveS_ID_data}"]
    # Reject
    Click Element    xpath=//*[@onclick="call_reject_popup(${check_LeaveS_ID_data});"]
    Sleep    5s
    Click Element    xpath=//*[@onclick="beforeRejectAction();"]
    ${Status_Appr_Rej}=    Get Text    xpath=//*[@class="app0-${check_LeaveS_ID_data}"]
    Should Be True    '${Status_Appr_Rej}' == 'Reject'
    
    Sleep    5s
    Capture Page Screenshot    34_2_HR_Reject.png
    Reload Page
    Sleep    5s

    Click For Log Out

    # ----------------------------- Find MyLeave ----------------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    # Check Leave ID
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' == '${check_LeaveS_ID_data2}'

    # Check Status
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Reject'
    
    Sleep    5s
    Capture Page Screenshot    34_3_MyLeave_Reject.png
    Sleep    5s

TC-LEAVE-EMP-035 P_Find_MyLeave_Delete
    
    IT Click MyLeave Button
    Click Add Leave
    Wait Until Page Contains    ${it_name}

    # Select Type of leave >>> ลาอื่นๆ
    Click Element    xpath=//*[@id="leaveTypes"]/label[2]
    Radio Button Should Be Set To    leaveType    2
    
    # Select Duration
    # select start date >>> 02-08-2021
    Click Element    id=date_from
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # select start date >>> 02-08-2021
    Click Element    id=date_to
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    # Input & Check Description
    Input Text    id=description    TC-LEAVE-034
    ${check_description}=    Get Value    xpath=//*[@id="description"]
    Should Be True    '${check_description}' == 'TC-LEAVE-034'
    
    
    # Click Submit Button
    Click Element    xpath=//*[@class="btn btn-sm blue-soft"]

    Wait Until Location Is    http://uat.cubesofttech.com/leavecalendar
    IT Click MyLeave Button

    # Check data from table

    # Check Leave ID
    ${check_Leave_ID}=    Get Table Cell    ${table}    1    1
    ${check_LeaveS_ID_data}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID'

    # Check Status
    ${check_LeaveStatus}=    Get Table Cell    ${table}    1    8
    ${check_LeaveStatus_data}=    Get Table Cell    ${table}    2    8
    Should Be True    '${check_LeaveStatus}' == 'Status' and '${check_LeaveStatus_data}' == 'Waiting for approve'

    Sleep    5s
    Capture Page Screenshot    35_1_MyLeave_WaitingForApprove.png
    Sleep    5s
    
    # Logout
    Click For Log Out

    # -------------------------------- Hr Delete Part -------------------------------------------#
    
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
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[2]    # select date

    
    # seleck staff btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[1]/div[1]/span
    
    # select input btn for add input 
    Click Element    xpath=/html/body/span/span/span[1]/input
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER
    
    # click search btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div/div[1]/div/div[2]/button
    Sleep    5s

    # select for click Delete
    Capture Page Screenshot    35_2_Before_HR_Delete.png
    # Delete
    Click Element    xpath=//*[@onclick="delTimesheet(${check_LeaveS_ID_data});"]
    Sleep    5s
    Click Element    class:sa-confirm-button-container
    Sleep    5s
    Capture Page Screenshot    35_3_After_HR_Delete.png
    Reload Page
    Sleep    5s

    Click For Log Out

    # ----------------------------- Find MyLeave ----------------------------------------#

    Employee Login Success2
    IT Click MyLeave Button

    # Check Leave ID
    ${check_LeaveS_ID_data2}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_Leave_ID}' == 'Leave ID' and '${check_LeaveS_ID_data}' != '${check_LeaveS_ID_data2}'
    
    Sleep    5s
    Capture Page Screenshot    35_4_MyLeave_Delete.png
    Sleep    5s

TC-LEAVE-EMP-036 P_Find_MyLeave_Day_Found

    IT Click MyLeave Button

    # search date
    # select start date >>> 01-08-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[2]/td[1]    # select date

    # select end date >>> 25-08-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[4]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    36_1_Find_MyLeave_Day.png

    # search date
    # select start date >>> 02-08-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[2]/td[2]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 24-08-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[3]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    36_2_Find_MyLeave_Day.png

    ${Fail}=    Run Keyword And Return Status    Should Be True    ${count_row_range} == ${count_row}
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    
    Log To Console    This Test Case ${Fail}

TC-LEAVE-EMP-037 P_Find_MyLeave_Day_Found

    IT Click MyLeave Button

    # search date
    # select start date >>> 31-08-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[6]/td[3]   # select date

    # select end date >>> 02-09-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[5]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    37_1_Find_MyLeave_Day.png

    # search date
    # select start date >>> 01-09-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[4]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 21-09-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[4]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    37_2_Find_MyLeave_Day.png

    ${Fail}=    Run Keyword And Return Status    Should Be True    ${count_row_range} == ${count_row}
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case ${Fail}

TC-LEAVE-EMP-038 P_Find_MyLeave_Day_Not_Found

    IT Click MyLeave Button

    # search date
    # select start date >>> 01-01-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[6]   # select date

    # select end date >>> 03-01-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[2]/td[1]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    38_1_Find_MyLeave_Day.png

    # search date
    # select start date >>> 02-01-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[7]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 02-01-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[7]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    38_2_Find_MyLeave_Day.png

    Should Be True    ${count_row_range} == ${count_row}
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case False

TC-LEAVE-EMP-039 P_Find_MyLeave_Mont_Found
    
    IT Click MyLeave Button

    # search date
    # select start date >>> 31-08-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[6]/td[3]   # select date

    # select end date >>> 01-10-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[10]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[6]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    39_1_Find_MyLeave_Mont.png

    # search date
    # select start date >>> 01-09-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[4]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 30-09-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[9]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[5]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    39_2_Find_MyLeave_Mont.png

    ${Fail}=    Run Keyword And Return Status    Should Be True    ${count_row_range} == ${count_row}
    Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case ${Fail}

TC-LEAVE-EMP-040 P_Find_MyLeave_Mont_Not_Found

    IT Click MyLeave Button

    # search date
    # select start date >>> 30-06-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[6]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[4]   # select date

    # select end date >>> 01-08-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[8]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[2]/td[1]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    40_1_Find_MyLeave_Mont.png

    # search date
    # select start date >>> 01-07-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[7]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[5]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 31-07-2021
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[7]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[7]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    40_2_Find_MyLeave_Mont.png

    Should Be True    ${count_row_range} == ${count_row}
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case False

TC-LEAVE-EMP-041 P_Find_MyLeave_Year_Found

    IT Click MyLeave Button

    # search date
    # select start date >>> 31-12-2021
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[6]   # select date

    # select end date >>> 01-01-2023
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[3]    # select for next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[3]    # select for next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[2]/td[1]    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    41_1_Find_MyLeave_Year.png

    # search date
    # select start date >>> 01-01-2022
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[3]    # select next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[7]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 31-12-2022
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[5]/td[7]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    41_2_Find_MyLeave_Year.png

    Should Be True    ${count_row_range} == ${count_row}
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case False

TC-LEAVE-EMP-042 P_Find_MyLeave_Year_Not_Found

    Employee Login Success

    IT Click MyLeave Button

    # search date
    # select start date >>> 31-12-2018
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[6]/td[2]   # select date

    # select end date >>> 01-01-2020
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]   # select for select year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # select for prev year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[4]    
    # Click Element    xpath=    # select date

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s

    # Count Table
    ${count_row_range}=    Get Element Count    ${table_body}
    Capture Page Screenshot    42_1_Find_MyLeave_Year.png

    # search date
    # select start date >>> 01-01-2019
    Click Element    name=startdate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]    # select for select year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # select next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # select next year
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[1]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[1]/td[3]    # select date
    ${startDay_check_before_search}=    Get Value    xpath=//*[@name="startdate"]

    # select end date >>> 31-12-2019
    Click Element    name=enddate
    Click Element    xpath=/html/body/div[4]/div[1]/table/thead/tr[2]/th[2]
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]    # select for select mont
    Click Element    xpath=/html/body/div[4]/div[2]/table/thead/tr[2]/th[1]
    Click Element    xpath=/html/body/div[4]/div[2]/table/tbody/tr/td/span[12]    # select mont
    Click Element    xpath=/html/body/div[4]/div[1]/table/tbody/tr[6]/td[3]    # select date
    ${endDay_check_before_search}=    Get Value    xpath=//*[@name="enddate"]

    # click searck button
    Click Element    xpath=//*[@id="search"]
    Sleep    5s
    
    # Count Table
    ${count_row}=    Get Element Count    ${table_body}
    Capture Page Screenshot    42_2_Find_MyLeave_Year.png

    Should Be True    ${count_row_range} == ${count_row}
    
    ${startDay_check_after_search}=    Get Value    xpath=//*[@name="startdate"]
    ${endDay_check_after_search}=    Get Value    xpath=//*[@name="enddate"]
    
    ${compare_start_date}=    Run Keyword And Return Status    Should Be True    '${startDay_check_before_search}' == '${startDay_check_after_search}'
    Run Keyword Unless    ${compare_start_date}    Log To Console    This step ${compare_start_date}!

    ${compare_end_date}=    Run Keyword And Return Status    Should Be True    '${endDay_check_before_search}' == '${endDay_check_after_search}'
    Run Keyword Unless    ${compare_end_date}    Log To Console    This step ${compare_end_date}!
    
    Log To Console    This Test Case False

    Close All Browsers