*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime
Library    BuiltIn
Library    OperatingSystem

*** Variable ***
${id_login}    test_it_roles
${id_name}    IT ROLE TESTING

${hr_login}    test_hr_role
${hr_name}    HR ROLE TESTING

${admin_login}    test_admin_role
${admin_name}    Admin Role Testing

${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome

${pic_directory}    D:/CO-OP/CubeSoftTech_WorkingSpace/Code/CheckList/Picture/

${table_name}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr      # for count
${table}    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]


*** Keywords ***
Check-in-btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[1]
    Radio Button Should Be Set To    work_hours_type    1
Check-out-btn
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[1]/div/div[2]/div/div[1]/form/div[1]/div/div[1]/div[2]
    Radio Button Should Be Set To    work_hours_type    2
Click Accept
    Click Element    xpath=//*[@id="checktime"]
Click Cancel
    Click Element    xpath=//*[@class="btn btn-primary red-intense"]
Click Check List
    Click Element    xpath=//*[@href="check_list?userId=${id_login}"]
    Title Should Be    check list
HR Click Check List
    Click Element    xpath=//*[@href="check_list?userId=${hr_login}"]
    Title Should Be    check list
Admin Click Check List
    Click Element    xpath=//*[@href="check_list?userId=${admin_login}"]
    Title Should Be    check list
Click prev time
    Click Element    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a
Click next time
    Click Element    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
Check-in_Check-out btn
    Click Element    xpath=//*[@href="check_in?userId=${id_login}"]
HR Check-in_Check-out btn
    Click Element    xpath=//*[@href="check_in?userId=${hr_login}"]
Admin Check-in_Check-out btn
    Click Element    xpath=//*[@href="check_in?userId=${admin_login}"]
Click Log out
    Click Element    xpath=/html/body/div[3]/div[1]/div/ul/li[1]/a
    Click Element    xpath=/html/body/div[1]/div/div[3]/div/ul/li/a
    Click Element    xpath=/html/body/div[1]/div/div[3]/div/ul/li/ul/li[3]/a

*** Test Case ***

TC-CHECK-000 Login-Success
    
    Open Browser    ${HOMEPAGE}    ${BROWSER}
    Maximize Browser Window
    Title Should Be    Cube SoftTech : Login
    Wait Until Page Contains    Login to your account
    Input Text    username    ${id_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    
    Title Should Be    check in
    Wait Until Page Contains    Welcome
    
    ${check_id}=    Get Text    xpath=/html/body/div[1]/div/div[3]/div/ul/li
    Should Be True    '${check_id}' == '${id_login}'
    Capture Page Screenshot    ${pic_directory}0_login.png

    # ------------------------------------- check in part ------------------------------------------------- #

TC-CHECK-001 successfully-check-in-late

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Late'

        Sleep    2s
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}1_successfully-check-in-late.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}1_successfully-check-in-late.png
    
    END

TC-CHECK-002 successfully-check-in-on-time
    
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*
    
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    IF    ${remove} >= 9 and ${remove} <= 16

        ${click_count}    set variable  ${{${remove} - 8}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    ${click_count}
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-002
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    ${click_count}h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result} =    Split String From Right    ${Convert}    :    1

        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'


        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_successfully-check-in-on-time.png
    
    ELSE IF    ${remove} >= 17 and ${remove} <= 23
        
        ${click_count}    set variable  ${{${remove} - 15}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    ${click_count}
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-002
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    ${click_count}h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result} =    Split String From Right    ${Convert}    :    1

        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_successfully-check-in-on-time.png

    ELSE

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    ${click_count}h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result}=    Split String From Right    ${Convert}    :    1


        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'

        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_successfully-check-in-on-time.png

    END

TC-CHECK-003 successfully-check-in-advance-working-day
    
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    ${current_time}=    Get Current Date    result_format=%H:%M

    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-003
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}3_successfully-check-in-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}3_successfully-check-in-advance-working-day.png
    END

TC-CHECK-004 unsuccessfully-check-in-advance-working-day
    
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    ${current_time}=    Get Current Date    result_format=%H:%M

    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-004
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}4_unsuccessfully-check-in-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}4_unsuccessfully-check-in-advance-working-day.png
    END

TC-CHECK-005 successfully-check-in-back-working-day

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 11 and ${remove} <= 23

        # ${click_count}    set variable  ${{${remove} - 2}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-005
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    2h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result} =    Split String From Right    ${Convert}    :    1

        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'


        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Late'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}5_successfully-check-in-back-working-day.png
    
    ELSE IF    ${remove} >= 3 and ${remove} <= 9
        
        # ${click_count}    set variable  ${{${remove} - 2}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-005
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    2h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result} =    Split String From Right    ${Convert}    :    1

        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}5_successfully-check-in-back-working-day.png

    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}5_successfully-check-in-back-working-day.png
    END

TC-CHECK-006 successfully-check-in-tomorrow

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]
    
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-006
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}6_successfully-check-in-tomorrow.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}6_successfully-check-in-tomorrow.png
    END


TC-CHECK-007 unsuccessfully-check-in-tomorrow

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]
    
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-007
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}7_unsuccessfully-check-in-tomorrow.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}7_unsuccessfully-check-in-tomorrow.png
    END

TC-CHECK-008 successfully-check-in-yesterday

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    ############################################# edit date ########################################################
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]
    ############################################# edit date ########################################################
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-008
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Last.
        Capture Page Screenshot    ${pic_directory}8_successfully-check-in-yesterday.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}8_successfully-check-in-yesterday.png
    END
  
TC-CHECK-009 unsuccessfully-check-in-yesterday

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    ############################################# edit date ########################################################
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]
    ############################################# edit date ########################################################
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-009
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Last.
        Capture Page Screenshot    ${pic_directory}9_unsuccessfully-check-in-yesterday.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}9_unsuccessfully-check-in-yesterday.png
    END

TC-CHECK-010 successfully-re-check-in

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Late'

        Sleep    2s
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_1_successfully-re-check-in.png
    
    ELSE IF    ${remove} >= 0 and ${remove} <= 8

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Sleep    2s
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_1_successfully-re-check-in.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}10_1_successfully-re-check-in.png
    
    END

    #------------------------------------------ re check in -----------------------------------------------#

    Check-in_Check-out btn
    Reload Page
    Check-in-btn

    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Late'

        Sleep    2s
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_2_successfully-re-check-in.png
    
    ELSE IF    ${remove} >= 0 and ${remove} <= 8

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Sleep    2s
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_2_successfully-re-check-in.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}10_2_successfully-re-check-in.png
    
    END

    #--------------------------------------------- Check out part ------------------------------------------------#

TC-CHECK-011 successfully-check-out-finished-work
    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Check-in-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*
    
    
    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    9
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-011
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

        # compare worktime
        ${TIME_sub}    Subtract Time From Time    ${Mydate}    9h   verbose
        ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
        ${result} =    Split String From Right    ${Convert}    :    1

        ${check_type_data_split}=    Split String    ${check_type_data}

        Should Be True    '${check_type}' == 'Work Time'
        Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
        Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
        Should Be True    '${check_type_data_split}[2]' == '${check_des}'


        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}11_1_successfully-check-out-finished-work.png


    #----------------------------------------- check out ----------------------------------------------------------#

    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Sleep    2s
    Check-out-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    '${split_hrs}' == '8'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Finished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}11_2_successfully-check-out-finished-work.png
    
    ELSE

        Log To Console    You Should Run Code at 9.00 AM onwards.
        Capture Page Screenshot    ${pic_directory}11_successfully-check-out-finished-work.png

    END

TC-CHECK-012 successfully-check-out-unfinished-work

    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    Check-in-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*
    
    
    IF    ${remove} >= 9 and ${remove} <= 23


        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    1
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-012
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >> Work Time
        ${check_type}=    Get Table Cell    ${table}     1    3
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
        ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y


        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_1_successfully-check-out-unfinished-work.png


    #----------------------------------------- check out part ----------------------------------------------------------#

    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Sleep    2s
    Check-out-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    '${split_hrs}' != '8'


    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Unfinished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_2_successfully-check-out-unfinished-work.png
    
    ELSE

        Log To Console    You Should Run Code at 9.00 AM onwards.
        Capture Page Screenshot    ${pic_directory}12_successfully-check-out-unfinished-work.png

    END

TC-CHECK-013 successfully-check-out-advance-working-day
    
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn
    ${current_time}=    Get Current Date    result_format=%H:%M

    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-013
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}13_successfully-check-out-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}13_successfully-check-out-advance-working-day.png
    END

TC-CHECK-014 unsuccessfully-check-out-advance-working-day
    
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn
    ${current_time}=    Get Current Date    result_format=%H:%M

    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-014
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}14_unsuccessfully-check-out-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}14_unsuccessfully-check-out-advance-working-day.png
    END

TC-CHECK-015 successfully-check-out-back-working-day

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*
    
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    IF    ${remove} >= 9 and ${remove} <= 16

        ${click_count}    set variable  ${{${remove} - 8}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    ${click_count}
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-015
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_1_successfully-check-out-back-working-day.png
    
    ELSE IF    ${remove} >= 17 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    15
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-015
        ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}


        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'


        # compare data >>  Woriking
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_1_successfully-check-out-back-working-day.png

    ELSE

        Click Accept
        Click Check List

        # count table for check last check in / check out
        ${count_table}=    Get element count    ${table_name}
        ${sum_count_table}    set variable  ${{${count_table} + 1}}

        # compare data >> User
        ${check_user}=    Get Table Cell    ${table}     1    1
        ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
        Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

        # compare data >> Type
        ${check_type}=    Get Table Cell    ${table}     1    2
        ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
        Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

        # compare data >>  Working
        ${check_working}=    Get Table Cell    ${table}     1    5
        ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
        Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

        # compare data >>  Status
        ${check_status}=    Get Table Cell    ${table}     1    6
        ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
        Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'On Time'

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_1_successfully-check-out-back-working-day.png

    END
    
    # ------------------------------------------------------ check out part ------------------------------------------#
    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Check-out-btn
        
    Click Element    xpath=//*[@id="ourtime"]
    
    FOR    ${i}    IN RANGE    2
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
        Run Keyword If   '${present}' == 'True'    Click prev time  
    END
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    Input Text    xpath=//*[@id="detail"]    TC-CHECK-015
    ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    # compare worktime
    ${TIME_sub}    Subtract Time From Time    ${Mydate}    2h   verbose
    ${Convert}    Convert Time    ${TIME_sub}    timer    exclude_millis=yes
    ${result} =    Split String From Right    ${Convert}    :    1

    ${check_type_data_split}=    Split String    ${check_type_data}

    Should Be True    '${check_type}' == 'Work Time'
    Should Be True    '${check_type_data_split}[0]' == '${current_date_format}'
    Should Be True    '${check_type_data_split}[1]' == '${result}[0]'
    Should Be True    '${check_type_data_split}[2]' == '${check_des}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    ${split_hrs} <= 8

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Unfinished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_2_successfully-check-out-back-working-day.png
    
TC-CHECK-016 unsuccessfully-check-out-tomorrow

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]

    ############################################# edit date ########################################################
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]
    ############################################# edit date ########################################################
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-016
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Future.
        Capture Page Screenshot    ${pic_directory}16_unsuccessfully-check-out-tomorrow.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-017 successfully-check-out-tomorrow

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]

    ############################################# edit date ########################################################
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]
    ############################################# edit date ########################################################
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-017
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Future.
        Capture Page Screenshot    ${pic_directory}17_successfully-check-out-tomorrow.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-018 unsuccessfully-check-out-yesterday

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]
    
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-018
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Last.

        Capture Page Screenshot    ${pic_directory}18_unsuccessfully-check-out-yesterday.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}18_unsuccessfully-check-out-yesterday.png
    END

TC-CHECK-019 successfully-check-out-yesterday

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M

    # click date picker
    Click Element    xpath=//*[@id="mydate"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]
    
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' != '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-019
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Last.

        Capture Page Screenshot    ${pic_directory}19_successfully-check-out-yesterday.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}19_successfully-check-out-yesterday.png
    END 

TC-CHECK-020 successfully-re-check-out

    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    Check-in-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]

    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

    # compare data >>  Working
    ${check_working}=    Get Table Cell    ${table}     1    5
    ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}20_1_successfully-re-check-out.png

    #----------------------------------------- check out part ----------------------------------------------------------#

    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Sleep    2s
    Check-out-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    '${split_hrs}' != '8'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Unfinished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}20_2_successfully-re-check-out.png
    
    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Sleep    2s
    Check-out-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    '${split_hrs}' != '8'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Unfinished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}20_3_successfully-re-check-out.png

TC-CHECK-021 successfully-check-out-re-check-in

    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    Check-in-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'


    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

    # compare data >>  Working
    ${check_working}=    Get Table Cell    ${table}     1    5
    ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}21_1_successfully-check-out-re-check-in.png

    #------------------------------------------ re check in ----------------------------------------------------------#
    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    
    Check-in-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'เข้างาน'

    # compare data >>  Working
    ${check_working}=    Get Table Cell    ${table}     1    5
    ${check_working_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_working}' == 'Working' and '${check_working_data}' == 'Check - In'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}21_2_successfully-check-out-re-check-in.png

    #----------------------------------------- check out part ----------------------------------------------------------#

    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${Mydate}    Get Current Date    result_format=%H:%M:%S
    Sleep    2s
    Check-out-btn
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'
    
    Click Accept
    Click Check List

    # count table for check last check in / check out
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # compare data >> User
    ${check_user}=    Get Table Cell    ${table}     1    1
    ${check_user_data}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user}' == 'User' and '${check_user_data}' == '${id_login}'

    # compare data >> Type
    ${check_type}=    Get Table Cell    ${table}     1    2
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_type}' == 'Type' and '${check_type_data}' == 'ออกงาน'

    # compare data >> Work Time
    ${check_type}=    Get Table Cell    ${table}     1    3
    ${check_type_data}=    Get Table Cell    ${table}    ${sum_count_table}    3
    ${current_date_format}    Convert Date    ${current_date}    date_format=%d-%m-%Y    result_format=%d-%b-%Y

    Should Be True    '${check_type}' == 'Work Time' and '${check_type_data}' == '${current_date_format} ${current_time}'

    # compare data >>  Working
    ${check_hrs}=    Get Table Cell    ${table}     1    5
    ${check_hrs_data}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_hrs}' == 'Working'
    ${split_hrs}=    Remove String Using Regexp    ${check_hrs_data}    :.*
    Should Be True    '${split_hrs}' != '8'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Unfinished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}21_3_successfully-check-out-re-check-in.png
    
TC-CHECK-022 unsuccessfully-check-in-notification

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M 
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    กรุณาระบุเหตุผลการลงเวลาย้อนหลังมากกว่า 10 ตัวอักษร

        Capture Page Screenshot    ${pic_directory}22_unsuccessfully-check-in-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-023 successfully-check-in-notification

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

    ${current_time}=    Get Current Date    result_format=%H:%M 
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Click Accept
        Sleep    3s

        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    กรุณาระบุเหตุผลการลงเวลาย้อนหลังมากกว่า 10 ตัวอักษร

        Capture Page Screenshot    ${pic_directory}23_successfully-check-in-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-024 unsuccessfully-check-out-notification

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M 
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    กรุณาระบุเหตุผลการลงเวลาย้อนหลังมากกว่า 10 ตัวอักษร

        Capture Page Screenshot    ${pic_directory}24_unsuccessfully-check-out-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-025 successfully-check-out-notification

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-out-btn

    ${current_time}=    Get Current Date    result_format=%H:%M 
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # check time
    ${check_time}=    Get Value    xpath=//*[@id="ourtime"]
    
    ${remove}=    Remove String Using Regexp    ${check_time}    :.*

    IF    ${remove} >= 9 and ${remove} <= 23
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Click Accept
        Sleep    3s
        ${Fail}=    Run Keyword And Return Status    Location Should Be    http://uat.cubesofttech.com/check_list?userId=${id_login}
        Run Keyword Unless    ${Fail}    Log To Console    This step ${Fail}!

        Page Should Contain    Here's a message!
        Page Should Contain    กรุณาระบุเหตุผลการลงเวลาย้อนหลังมากกว่า 10 ตัวอักษร

        Capture Page Screenshot    ${pic_directory}25_successfully-check-out-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-026 successfully-cancel
    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    
    # check date picker
    ${check_date}=    Get Value    xpath=//*[@id="mydate"]
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Should Be True    '${check_date}' == '${current_date}'

    # # check time
    ${check_time1}=    Get Value    xpath=//*[@id="ourtime"]

    Click Element    xpath=//*[@id="ourtime"]
    FOR    ${i}    IN RANGE    2
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
        Run Keyword If   '${present}' == 'True'    Click prev time  
    END
    ${check_time2}=    Get Value    xpath=//*[@id="ourtime"]
    
    Input Text    xpath=//*[@id="detail"]    TC-CHECK-026
    ${check_des}=    Get Value    xpath=//*[@id="detail"]
    
    Click Cancel

    Wait Until Element Is Not Visible    xpath=//*[@id="detail"]
    ${check_time3}=    Get Value    xpath=//*[@id="ourtime"]

    Should Be True    '${check_time1}' != '${check_time2}' and '${check_time2}' != '${check_time3}'

    Capture Page Screenshot    ${pic_directory}26_successfully-cancel.png

TC-CHECK-027 successfully-search-by-day

    Click Check List
    Click Element    xpath=//*[@id="F-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[3]    # for select day

    Click Element    xpath=//*[@id="E-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[3]    # for select day

    Click Element    xpath=//*[@id="searchbutton"]    # search btn

    Sleep    5s

    ${count_table}=    Get element count    ${table_name}

    IF    ${count_table} > 0
        Log To Console    Found the check-in / check out in this day.
    ELSE
        Log To Console    Not found the check-in / check out in this day.
    END

    Wait Until Page Contains    14-Sep-2021

    Capture Page Screenshot    ${pic_directory}27_successfully-search-by-day.png

TC-CHECK-028 successfully-search-by-month

    Click Check List
    Click Element    xpath=//*[@id="F-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # for select day

    Click Element    xpath=//*[@id="E-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]    # for select day

    Click Element    xpath=//*[@id="searchbutton"]    # search btn

    Sleep    5s

    ${count_table}=    Get element count    ${table_name}

    IF    ${count_table} > 0
        Log To Console    Found the check-in / check out in this month.
    ELSE
        Log To Console    Not found the check-in / check out in this month.
    END

    Wait Until Page Contains    Sep-2021

    ${start_date}=    get value    xpath=//*[@id="F-date"]
    Should Be True    '${start_date}' == '01-09-2021'

    ${end_date}=    get value    xpath=//*[@id="E-date"]
    Should Be True    '${end_date}' == '30-09-2021'
    
    Capture Page Screenshot    ${pic_directory}28_successfully-search-by-month.png

TC-CHECK-029 successfully-search-by-year

    Click Check List
    Click Element    xpath=//*[@id="F-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[1]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[6]    # for select day

    Click Element    xpath=//*[@id="E-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[12]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[6]    # for select day

    Click Element    xpath=//*[@id="searchbutton"]    # search btn

    Sleep    5s

    ${count_table}=    Get element count    ${table_name}

    IF    ${count_table} > 0
        Log To Console    Found the check-in / check out in this month.
    ELSE
        Log To Console    Not found the check-in / check out in this month.
    END

    ${start_date}=    get value    xpath=//*[@id="F-date"]
    Should Be True    '${start_date}' == '01-01-2021'

    ${end_date}=    get value    xpath=//*[@id="E-date"]
    Should Be True    '${end_date}' == '31-12-2021'

    Capture Page Screenshot    ${pic_directory}29_successfully-search-by-year.png


TC-CHECK-030 successfully-HR-edit-data

    Click Log out
    
    Input Text    username    ${admin_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome

    # Click Accept
    Admin Click Check List

    ${count_table}=    Get element count    ${table_name}
    Sleep    3s
    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[1]    ${pic_directory}30_1_successfully-HR-edit-data.png

    # click edit
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[2]/div/table/tbody/tr/td[7]/a

    ${time_before_edit}=    get value    xpath=//*[@id="ourtime"]

    Click Element    xpath=//*[@id="ourtime"]
    FOR    ${i}    IN RANGE    2
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
        Run Keyword If   '${present}' == 'True'    Click Element    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
    END

    ${time_after_edit}=    get value    xpath=//*[@id="ourtime"]

    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[6]/button[1]

    # check date
    Should Be True    '${time_before_edit}' != '${time_after_edit}'
    
    Sleep    3s
    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[1]    ${pic_directory}30_2_successfully-HR-edit-data.png

    # back to before edit
    Admin Click Check List
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/div[2]/div/table/tbody/tr/td[7]/a
    Click Element    xpath=//*[@id="ourtime"]
    FOR    ${i}    IN RANGE    2
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a
        Run Keyword If   '${present}' == 'True'    Click Element    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a
    END
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[2]/form/div[6]/button[1]

TC-CHECK-031 successfully-HR-search-by-name

    Click Log out
    
    Input Text    username    ${hr_login}
    Input Password    password    1234
    Click button    id=submit myBtn
    Title Should Be    check in
    Wait Until Page Contains    Welcome

    HR Click Check List
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div/div[1]/span/span[1]/span
    # input name
    Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER

    Click Element    xpath=//*[@id="F-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # for select day

    Click Element    xpath=//*[@id="E-date"]
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]    # for select day

    Click Element    xpath=//*[@id="searchbutton"]    # search btn

    # Sleep    5s

    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    IF    ${count_table} > 0
        Log To Console    Found the check-in / check out in this month.
    ELSE
        Log To Console    Not found the check-in / check out in this month.
    END

    Wait Until Page Contains    Sep-2021

    ${search_name}=    get text    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div/div[1]/span/span[1]/span

    ${start_date}=    get value    xpath=//*[@id="F-date"]
    Should Be True    '${start_date}' == '01-09-2021'

    ${end_date}=    get value    xpath=//*[@id="E-date"]
    Should Be True    '${end_date}' == '30-09-2021'
    
    # compare data >> User
    ${check_user_data_start}=    Get Table Cell    ${table}    2    1
    Should Be True    '${check_user_data_start}' == '${id_login}'

    ${check_user_data_end}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_user_data_end}' == '${id_login}'
    
    Capture Page Screenshot    ${pic_directory}31_successfully-HR-search-by-name.png



#############################################################################################################
#############################################################################################################
#############################################################################################################
#############################################################################################################


# TC-CHECK-032 successfully-HR-download-file

#     Click Log out
    
#     Input Text    username    ${hr_login}
#     Input Password    password    1234
#     Click button    id=submit myBtn
#     Title Should Be    check in
#     Wait Until Page Contains    Welcome

#     HR Click Check List
#     Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div/div[1]/span/span[1]/span
    
#     # input name
#     Press Keys    xpath=/html/body/span/span/span[1]/input    IT ROLE TESTING    ENTER

#     Click Element    xpath=//*[@id="F-date"]
#     Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
#     Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
#     Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[1]/td[4]    # for select day

#     Click Element    xpath=//*[@id="E-date"]
#     Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # for select month
#     Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]
#     Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[5]/td[5]    # for select day

#     Click Element    xpath=//*[@id="searchbutton"]    # search btn

#     Sleep    5s

#     ${count_table}=    Get element count    ${table_name}

#     IF    ${count_table} > 0
#         Log To Console    Found the check-in / check out in this month.
#     ELSE
#         Log To Console    Not found the check-in / check out in this month.
#     END

#     Wait Until Page Contains    Sep-2021

#     ${search_name}=    get text    xpath=/html/body/div[3]/div[2]/div/div[2]/form/div/div/div[1]/span/span[1]/span

#     ${start_date}=    get value    xpath=//*[@id="F-date"]
#     Should Be True    '${start_date}' == '01-09-2021'

#     ${end_date}=    get value    xpath=//*[@id="E-date"]
#     Should Be True    '${end_date}' == '30-09-2021'

#     Click Element    xpath=//*[@id="hrefPdf"]

    # Title Should Be    CheckListReport
    # Wait Until Page Contains    ${id_name}
    # Wait Until Page Contains    01-Sep-2021 and 30-Sep-2021

    # Click Element    xpath=//*[@id="icon"]/iron-icon


    # File Should Not Be Empty    C:\\Downloads\chcekList.pdf
    
    # Capture Page Screenshot    ${pic_directory}32_successfully-HR-download-file.png
    

    Close All Browsers