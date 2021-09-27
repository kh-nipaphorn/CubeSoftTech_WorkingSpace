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
Click Check List
    Click Element    xpath=//*[@href="check_list?userId=${id_login}"]
    Title Should Be    check list
Click prev time
    Click Element    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a
Click next time
    Click Element    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
Check-in_Check-out btn
    Click Element    xpath=//*[@href="check_in?userId=${id_login}"]


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

#--------------------------------------------------- Check in part -----------------------------------------------------------#
    
TC-CHECK-001 Check-in-late

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
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}1_check-in-late.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}1_check-in-late.png
    
    END
  
TC-CHECK-002 Check-in-on-time
    
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_check-in-on-time.png
    
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_check-in-on-time.png

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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}2_check-in-on-time.png

    END


TC-CHECK-003 Check-in-post-time-in-advance-working-day
    
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

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}3_Check-in-post-time-in-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}3_Check-in-post-time-in-advance-working-day.png
    END
  

TC-CHECK-004 Check-in-post-time-in-back-working-day

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-004
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}4_Check-in-post-time-in-back-working-day.png
    
    ELSE IF    ${remove} >= 3 and ${remove} <= 9
        
        # ${click_count}    set variable  ${{${remove} - 2}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[3]/td[1]/a  
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-004
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}4_Check-in-post-time-in-back-working-day.png

    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}4_Check-in-post-time-in-back-working-day.png
    END

TC-CHECK-005 Check-in-advance

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-005
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}5_Check-in-advance.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}5_Check-in-advance.png
    END

TC-CHECK-006 Check-in-back

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn

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
    # IF    ${remove} >= 9 and ${remove} <= 16
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click prev time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-006
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Last.
        Capture Page Screenshot    ${pic_directory}6_Check-in-back.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}6_Check-in-back.png
    END
  
TC-CHECK-007 re-check-in

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
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}7_1_re-check-in.png
    
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
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}7_1_re-check-in.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}7_1_re-check-in.png
    
    END

    #------------------------------------------ re check in -----------------------------------------------#

    Check-in_Check-out btn
    Reload Page
    Sleep    2s
    Check-in-btn
    Sleep    2s
    
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
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}7_2_re-check-in.png
    
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
        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}7_2_re-check-in.png
    
    ELSE
    
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}7_2_re-check-in.png
    
    END

#--------------------------------------------------- Check out part -----------------------------------------------------------#

TC-CHECK-008 check-out-waiting-for-approve
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
    Should Be True    '${split_hrs}' == 'N\A'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Wait For Approve'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}8_check-out-waiting-for-approve.png


TC-CHECK-009 check-out-Finished-work
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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-009
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}9_1_check-out-finished-work.png


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
    Should Be True    '${split_hrs}' == '8'

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Finished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}9_2_check-out-finished-work.png
    
    ELSE

        Log To Console    You Should Run Code at 9.00 AM onwards.
        Capture Page Screenshot    ${pic_directory}9_check-out-finished-work.png

    END

TC-CHECK-010 check-out-Unfinished-work

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-010
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_1_check-out-unfinished-work.png


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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}10_2_check-out-unfinished-work.png
    
    ELSE

        Log To Console    You Should Run Code at 9.00 AM onwards.
        Capture Page Screenshot    ${pic_directory}10_check-out-unfinished-work.png

    END

TC-CHECK-011 Check-out-post-time-in-advance-working-day
    
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

        # ${click_count}    set variable  ${{${remove} + 2}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    2
            ${present}=    Run Keyword And Return Status    Element Should Be Visible    xpath=/html/body/div[5]/table/tbody/tr[1]/td[1]/a
            Run Keyword If   '${present}' == 'True'    Click next time  
        END
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-011
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-In In Future.
        Capture Page Screenshot    ${pic_directory}11_Check-out-post-time-in-advance-working-day.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM
        Capture Page Screenshot    ${pic_directory}11_Check-out-post-time-in-advance-working-day.png
    END

TC-CHECK-012 Check-out-post-time-in-back-working-day

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-012
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_1_Check-out-post-time-in-back-working-day.png
    
    ELSE IF    ${remove} >= 17 and ${remove} <= 23
        
        # ${click_count}    set variable  ${{${remove} - 15}}
        
        Click Element    xpath=//*[@id="ourtime"]
    
        FOR    ${i}    IN RANGE    15
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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_1_Check-out-post-time-in-back-working-day.png

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

        Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_1_Check-out-post-time-in-back-working-day.png

    END
    
    # ------------------------------------------------------ check out part ------------------------------------------#
    Sleep    30s
    Check-in_Check-out btn
    Reload Page
    # ${current_time}=    Get Current Date    result_format=%H:%M
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
    Should Be True    ${split_hrs} > 8 or ${split_hrs} == 8

    # compare data >>  Status
    ${check_status}=    Get Table Cell    ${table}     1    6
    ${check_status_data}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_status}' == 'Status' and '${check_status_data}' == 'Finished Work'

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}12_2_check-out-finished-work.png
    
TC-CHECK-013 Check-out-advance

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-013
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Future.
        Capture Page Screenshot    ${pic_directory}13_Check-out-advance.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-014 Check-in-back

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
    
        Input Text    xpath=//*[@id="detail"]    TC-CHECK-014
    
        Click Accept
        Sleep    3s

        Page Should Contain    Here's a message!
        Page Should Contain    Can't Check-out In Last.

        Capture Page Screenshot    ${pic_directory}14_Check-out-back.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    ELSE
        Log To Console    You Should Run Code at 9.00 AM - 4.00 PM or Edit Date and Month xpath
        Capture Page Screenshot    ${pic_directory}14_Check-out-back.png
    END

TC-CHECK-015 re-check-out

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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_1_re-check-out.png

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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_2_re-check-out.png
    
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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}15_3_re-check-out.png

TC-CHECK-016 check-out-re-check-in

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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}16_1_check-out-re-check-in.png

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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}16_2_check-out-re-check-in.png

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

    Capture Element Screenshot    xpath=//*[@class="table table-striped table-condensed flip-content table-hover"]/tbody/tr[${count_table}]    ${pic_directory}16_3_check-out-re-check-in.png
    
TC-CHECK-017 check-in-notification

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

        Capture Page Screenshot    ${pic_directory}17_check-in-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

TC-CHECK-018 check-out-notification

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

        Capture Page Screenshot    ${pic_directory}18_check-out-notification.png
        Click Element    xpath=/html/body/div[6]/div[7]/div
    
    END

    Close All Browsers