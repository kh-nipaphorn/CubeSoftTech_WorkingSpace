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


#------------------ test case data ----------------#
${lecturer_data}    นิภาภรณ์ ขันติกิจ
${location_data}    160/170-2, 13A Fl., ITF-Silom Palace Building Silom Rd. Suriyawong Bangrak Bankok, 10500
${description_data}    Robot Framework Test


#--------------------- Browser -------------------#
${HOMEPAGE}    http://uat.cubesofttech.com/
${BROWSER}    chrome


# --------- Directory for save Picture ------------#
${pic_directory}    D:/RobotFramework/Training/Picture/


# ----------------- table data --------------------#
${table_name}    xpath=//*[@id="myTable"]/tbody/tr      # for count
${table}    xpath=//*[@id="myTable"]


*** Keywords ***

Click My Training
    Click Element    xpath=//*[@href="Training_list?Id=${id_login}"]
    Title Should Be    Training_list

HR Click My Training
    Click Element    xpath=//*[@href="Training_list?Id=${hr_login}"]
    Title Should Be    Training_list

Admin Click My Training
    Click Element    xpath=//*[@href="Training_list?Id=${admin_login}"]
    Title Should Be    Training_list

Click Add New
    Click Element    xpath=//*[@id="addLeave"]
    Title Should Be    Training_Add

Click Submit
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[3]/div/div/div[1]

Click Cancel
    Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[3]/div/div/div[2]

Click Logout
    Click Element    xpath=/html/body/div[1]/div/div[3]/div/ul/li/a
    Click Element    xpath=//*[@href="logout"]

Click Training Management
    Click Element    xpath=//*[@id="masterMenu"]
    Wait Until Element Is Visible    xpath=//*[@href="Training_list_Admin"]
    Click Element    xpath=//*[@href="Training_list_Admin"]


*** Test Case ***

Set-up Directory
    Create Directory    D:/RobotFramework/Training/Picture

TC-TRAIN-000 Login-Success
    
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

TC-TRAIN-002 Employees-can-add-past-training-records

    Click My Training
    Click Add New

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    ${lecturer_data}
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_data}' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      ${lecturer_data}
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-002
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-002'

    # check count length training title
    ${count_title_text}=    Get length      TC-TRAIN-002
    ${count_title_web}=    Get Text    xpath=//*[@id="current_count_2"]
    Should Be True    '${count_title_text}' == '${count_title_web}'

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[2]/td[7]    # select day 11-09-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[9]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[1]    # select day 12-09-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '11-09-2021' and '${date_to}' == '12-09-2021'
    
    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    2
    ${hour}=    get value    xpath=//*[@id="t_Hour"]
    
    # Location
    Input Text    xpath=//*[@id="location"]    ${location_data}
    ${location}=    get value    xpath=//*[@id="location"]
    
    # check count length training title
    ${count_lacation_text}=    Get length      ${location_data}
    ${count_lacation_web}=    Get Text    xpath=//*[@id="current_count_4"]
    Should Be True    '${count_lacation_text}' == '${count_lacation_web}'
    
    # Description
    Input Text    xpath=//*[@id="description"]    ${description_data}
    ${description}=    get value    xpath=//*[@id="description"]

    # check count length description title
    ${count_description_text}=    Get length      ${description_data}
    ${count_description_web}=    Get Text    xpath=//*[@id="current_count_5"]
    Should Be True    '${count_description_text}' == '${count_description_web}'

    Click Submit

    Click My Training

    # Check All Data -----------------------------------------------------------------------------

    # count table
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # Check name
    ${check_name_table}=    Get Table Cell    ${table}    1    2
    ${check_name}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_name_table}' == 'Name'
    Should Be True    '${check_name}' == '${id_login}'

    # Check Title
    ${check_title_table}=    Get Table Cell    ${table}    1    3
    ${check_title}=    Get Table Cell    ${table}    ${sum_count_table}    3
    Should Be True    '${check_title_table}' == 'Title'
    Should Be True    '${check_title}' == '${training_title}'

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    # Check Hour
    ${check_hour_table}=    Get Table Cell    ${table}    1    6
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_hour_table}' == 'Hour'
    Should Be True    '${check_hour}' == '${hour}:00'

    # Check Submit Date
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y

    ${check_submit_table}=    Get Table Cell    ${table}    1    7
    ${check_submit}=    Get Table Cell    ${table}    ${sum_count_table}    7
    Should Be True    '${check_submit_table}' == 'Submit Date'
    Should Be True    '${check_submit}' == '${current_date} ${current_time}'
    
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}2_Employees-can-add-past-training-records.png


TC-TRAIN-012 Employees-can-edit-the-Lecturer

    Click My Training
    Click Add New

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    นิภาภรณ์
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    'นิภาภรณ์' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      นิภาภรณ์
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-012
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-012'

    # check count length training title
    ${count_title_text}=    Get length      TC-TRAIN-012
    ${count_title_web}=    Get Text    xpath=//*[@id="current_count_2"]
    Should Be True    '${count_title_text}' == '${count_title_web}'

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '15-10-2021' and '${date_to}' == '15-10-2021'
    
    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    12
    ${hour}=    get value    xpath=//*[@id="t_Hour"]
    
    # Location
    Input Text    xpath=//*[@id="location"]    ${location_data}
    ${location}=    get value    xpath=//*[@id="location"]
    
    # check count length training title
    ${count_lacation_text}=    Get length      ${location_data}
    ${count_lacation_web}=    Get Text    xpath=//*[@id="current_count_4"]
    Should Be True    '${count_lacation_text}' == '${count_lacation_web}'
    
    # Description
    Input Text    xpath=//*[@id="description"]    ${description_data}
    ${description}=    get value    xpath=//*[@id="description"]

    # check count length description title
    ${count_description_text}=    Get length      ${description_data}
    ${count_description_web}=    Get Text    xpath=//*[@id="current_count_5"]
    Should Be True    '${count_description_text}' == '${count_description_web}'

    Capture Page Screenshot    ${pic_directory}12_1_Employees-can-edit-the-Lecturer.png

    Click Submit

    Click My Training

    # Check All Data -----------------------------------------------------------------------------

    # count table
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # Check name
    ${check_name_table}=    Get Table Cell    ${table}    1    2
    ${check_name}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_name_table}' == 'Name'
    Should Be True    '${check_name}' == '${id_login}'

    # Check Title
    ${check_title_table}=    Get Table Cell    ${table}    1    3
    ${check_title}=    Get Table Cell    ${table}    ${sum_count_table}    3
    Should Be True    '${check_title_table}' == 'Title'
    Should Be True    '${check_title}' == '${training_title}'

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    # Check Hour
    ${check_hour_table}=    Get Table Cell    ${table}    1    6
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_hour_table}' == 'Hour'
    Should Be True    '${check_hour}' == '${hour}:00'

    # Check Submit Date
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y

    ${check_submit_table}=    Get Table Cell    ${table}    1    7
    ${check_submit}=    Get Table Cell    ${table}    ${sum_count_table}    7
    Should Be True    '${check_submit_table}' == 'Submit Date'
    Should Be True    '${check_submit}' == '${current_date} ${current_time}'
    
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}12_2_Employees-can-edit-the-Lecturer.png

    Click My Training

    # Edit Data -----------------------------------------------------------------------------

    ${check_id_table}=    Get Table Cell    ${table}    1    1
    ${check_id}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_id_table}' == 'ID'

    Click Element    xpath=//*[@href="Training_Edit?trainingid=${check_id}"]

    Clear Element Text    xpath=//*[@id="lecturer"]

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    ${lecturer_data}
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_data}' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      ${lecturer_data}
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    Click Submit

    Click My Training
    Click Element    xpath=//*[@href="Training_Edit?trainingid=${check_id}"]
    ${lecturer_edit}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_edit}' == '${lecturer}'
    
    Capture Page Screenshot    ${pic_directory}12_3_Employees-can-edit-the-Lecturer.png

TC-TRAIN-013 Employees-can-edit-the-Training-Title

    Click My Training
    Click Add New

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    ${lecturer_data}
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_data}' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      ${lecturer_data}
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-012
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-012'

    # check count length training title
    ${count_title_text}=    Get length      TC-TRAIN-012
    ${count_title_web}=    Get Text    xpath=//*[@id="current_count_2"]
    Should Be True    '${count_title_text}' == '${count_title_web}'

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '15-10-2021' and '${date_to}' == '15-10-2021'
    
    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    12
    ${hour}=    get value    xpath=//*[@id="t_Hour"]
    
    # Location
    Input Text    xpath=//*[@id="location"]    ${location_data}
    ${location}=    get value    xpath=//*[@id="location"]
    
    # check count length training title
    ${count_lacation_text}=    Get length      ${location_data}
    ${count_lacation_web}=    Get Text    xpath=//*[@id="current_count_4"]
    Should Be True    '${count_lacation_text}' == '${count_lacation_web}'
    
    # Description
    Input Text    xpath=//*[@id="description"]    ${description_data}
    ${description}=    get value    xpath=//*[@id="description"]

    # check count length description title
    ${count_description_text}=    Get length      ${description_data}
    ${count_description_web}=    Get Text    xpath=//*[@id="current_count_5"]
    Should Be True    '${count_description_text}' == '${count_description_web}'

    Capture Page Screenshot    ${pic_directory}13_1_Employees-can-edit-the-Training-Title.png

    Click Submit

    Click My Training

    # Check All Data -----------------------------------------------------------------------------

    # count table
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # Check name
    ${check_name_table}=    Get Table Cell    ${table}    1    2
    ${check_name}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_name_table}' == 'Name'
    Should Be True    '${check_name}' == '${id_login}'

    # Check Title
    ${check_title_table}=    Get Table Cell    ${table}    1    3
    ${check_title}=    Get Table Cell    ${table}    ${sum_count_table}    3
    Should Be True    '${check_title_table}' == 'Title'
    Should Be True    '${check_title}' == '${training_title}'

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    # Check Hour
    ${check_hour_table}=    Get Table Cell    ${table}    1    6
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_hour_table}' == 'Hour'
    Should Be True    '${check_hour}' == '${hour}:00'

    # Check Submit Date
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y

    ${check_submit_table}=    Get Table Cell    ${table}    1    7
    ${check_submit}=    Get Table Cell    ${table}    ${sum_count_table}    7
    Should Be True    '${check_submit_table}' == 'Submit Date'
    Should Be True    '${check_submit}' == '${current_date} ${current_time}'
    
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}13_2_Employees-can-edit-the-Training-Title.png

    Click My Training

    # Edit Data -----------------------------------------------------------------------------

    ${check_id_table}=    Get Table Cell    ${table}    1    1
    ${check_id}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_id_table}' == 'ID'

    Click Element    xpath=//*[@href="Training_Edit?trainingid=${check_id}"]

    Clear Element Text    xpath=//*[@id="t_title"]

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-013
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-013'

    Click Submit
    Reload Page
    Sleep    2s

    Click My Training
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}13_3_Employees-can-edit-the-Training-Title.png

TC-TRAIN-014 Employees-can-edit-the-Duration

    Click My Training
    Click Add New

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    ${lecturer_data}
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_data}' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      ${lecturer_data}
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-014
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-014'

    # check count length training title
    ${count_title_text}=    Get length      TC-TRAIN-014
    ${count_title_web}=    Get Text    xpath=//*[@id="current_count_2"]
    Should Be True    '${count_title_text}' == '${count_title_web}'

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '15-10-2021' and '${date_to}' == '15-10-2021'
    
    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    14
    ${hour}=    get value    xpath=//*[@id="t_Hour"]
    
    # Location
    Input Text    xpath=//*[@id="location"]    ${location_data}
    ${location}=    get value    xpath=//*[@id="location"]
    
    # check count length training title
    ${count_lacation_text}=    Get length      ${location_data}
    ${count_lacation_web}=    Get Text    xpath=//*[@id="current_count_4"]
    Should Be True    '${count_lacation_text}' == '${count_lacation_web}'
    
    # Description
    Input Text    xpath=//*[@id="description"]    ${description_data}
    ${description}=    get value    xpath=//*[@id="description"]

    # check count length description title
    ${count_description_text}=    Get length      ${description_data}
    ${count_description_web}=    Get Text    xpath=//*[@id="current_count_5"]
    Should Be True    '${count_description_text}' == '${count_description_web}'

    Capture Page Screenshot    ${pic_directory}14_1_Employees-can-edit-the-Duration.png

    Click Submit

    Click My Training

    # Check All Data -----------------------------------------------------------------------------

    # count table
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # Check name
    ${check_name_table}=    Get Table Cell    ${table}    1    2
    ${check_name}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_name_table}' == 'Name'
    Should Be True    '${check_name}' == '${id_login}'

    # Check Title
    ${check_title_table}=    Get Table Cell    ${table}    1    3
    ${check_title}=    Get Table Cell    ${table}    ${sum_count_table}    3
    Should Be True    '${check_title_table}' == 'Title'
    Should Be True    '${check_title}' == '${training_title}'

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    # Check Hour
    ${check_hour_table}=    Get Table Cell    ${table}    1    6
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_hour_table}' == 'Hour'
    Should Be True    '${check_hour}' == '${hour}:00'

    # Check Submit Date
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y

    ${check_submit_table}=    Get Table Cell    ${table}    1    7
    ${check_submit}=    Get Table Cell    ${table}    ${sum_count_table}    7
    Should Be True    '${check_submit_table}' == 'Submit Date'
    Should Be True    '${check_submit}' == '${current_date} ${current_time}'
    
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}14_2_Employees-can-edit-the-Duration.png

    Click My Training

    # Edit Data -----------------------------------------------------------------------------

    ${check_id_table}=    Get Table Cell    ${table}    1    1
    ${check_id}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_id_table}' == 'ID'

    Click Element    xpath=//*[@href="Training_Edit?trainingid=${check_id}"]

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[2]    # select day 18-10-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[4]/td[2]    # select day 18-10-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '18-10-2021' and '${date_to}' == '18-10-2021'

    Click Submit
    Reload Page
    Sleep    2s

    Click My Training

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}14_3_Employees-can-edit-the-Duration.png

TC-TRAIN-015 Employees-can-edit-the-Hour-Training

    Click My Training
    Click Add New

    # lecturer
    input Text    xpath=//*[@id="lecturer"]    ${lecturer_data}
    ${lecturer}=    get value    xpath=//*[@id="lecturer"]
    Should Be True    '${lecturer_data}' == '${lecturer}'

    # check count length lecturer
    ${count_lecturer_text}=    Get length      ${lecturer_data}
    ${count_lecturer_web}=    Get Text    xpath=//*[@id="current_count_1"]
    Should Be True    '${count_lecturer_text}' == '${count_lecturer_web}'

    # training title
    input Text    xpath=//*[@id="t_title"]    TC-TRAIN-015
    ${training_title}=    get value    xpath=//*[@id="t_title"]
    Should Be True    '${training_title}' == 'TC-TRAIN-015'

    # check count length training title
    ${count_title_text}=    Get length      TC-TRAIN-015
    ${count_title_web}=    Get Text    xpath=//*[@id="current_count_2"]
    Should Be True    '${count_title_text}' == '${count_title_web}'

    # Duration
    # date from
    Click Element    xpath=//*[@id="date_from"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # date to
    Click Element    xpath=//*[@id="date_to"]    # click for insert date
    Click Element    xpath=/html/body/div[5]/div[1]/table/thead/tr[2]/th[2]    # click for select month
    Click Element    xpath=/html/body/div[5]/div[2]/table/tbody/tr/td/span[10]    # select month
    Click Element    xpath=/html/body/div[5]/div[1]/table/tbody/tr[3]/td[6]    # select day 15-10-2021

    # check duration
    ${date_from}=    get value    xpath=//*[@id="date_from"]
    ${date_to}=    get value    xpath=//*[@id="date_to"]
    Should Be True    '${date_from}' == '15-10-2021' and '${date_to}' == '15-10-2021'
    
    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    14
    ${hour}=    get value    xpath=//*[@id="t_Hour"]
    
    # Location
    Input Text    xpath=//*[@id="location"]    ${location_data}
    ${location}=    get value    xpath=//*[@id="location"]
    
    # check count length training title
    ${count_lacation_text}=    Get length      ${location_data}
    ${count_lacation_web}=    Get Text    xpath=//*[@id="current_count_4"]
    Should Be True    '${count_lacation_text}' == '${count_lacation_web}'
    
    # Description
    Input Text    xpath=//*[@id="description"]    ${description_data}
    ${description}=    get value    xpath=//*[@id="description"]

    # check count length description title
    ${count_description_text}=    Get length      ${description_data}
    ${count_description_web}=    Get Text    xpath=//*[@id="current_count_5"]
    Should Be True    '${count_description_text}' == '${count_description_web}'

    Capture Page Screenshot    ${pic_directory}15_1_Employees-can-edit-the-Hour-Training.png

    Click Submit

    Click My Training

    # Check All Data -----------------------------------------------------------------------------

    # count table
    ${count_table}=    Get element count    ${table_name}
    ${sum_count_table}    set variable  ${{${count_table} + 1}}

    # Check name
    ${check_name_table}=    Get Table Cell    ${table}    1    2
    ${check_name}=    Get Table Cell    ${table}    ${sum_count_table}    2
    Should Be True    '${check_name_table}' == 'Name'
    Should Be True    '${check_name}' == '${id_login}'

    # Check Title
    ${check_title_table}=    Get Table Cell    ${table}    1    3
    ${check_title}=    Get Table Cell    ${table}    ${sum_count_table}    3
    Should Be True    '${check_title_table}' == 'Title'
    Should Be True    '${check_title}' == '${training_title}'

    # Check Start Date
    ${check_start_table}=    Get Table Cell    ${table}    1    4
    ${check_start}=    Get Table Cell    ${table}    ${sum_count_table}    4
    Should Be True    '${check_start_table}' == 'Start Date'
    Should Be True    '${check_start}' == '${date_from}'

    # Check Until Date
    ${check_until_table}=    Get Table Cell    ${table}    1    5
    ${check_until}=    Get Table Cell    ${table}    ${sum_count_table}    5
    Should Be True    '${check_until_table}' == 'Until Date'
    Should Be True    '${check_until}' == '${date_to}'

    # Check Hour
    ${check_hour_table}=    Get Table Cell    ${table}    1    6
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${check_hour_table}' == 'Hour'
    Should Be True    '${check_hour}' == '${hour}:00'

    # Check Submit Date
    
    ${current_time}=    Get Current Date    result_format=%H:%M
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y

    ${check_submit_table}=    Get Table Cell    ${table}    1    7
    ${check_submit}=    Get Table Cell    ${table}    ${sum_count_table}    7
    Should Be True    '${check_submit_table}' == 'Submit Date'
    Should Be True    '${check_submit}' == '${current_date} ${current_time}'
    
    Sleep    2s
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}15_2_Employees-can-edit-the-Hour-Training.png

    Click My Training

    # Edit Data -----------------------------------------------------------------------------

    ${check_id_table}=    Get Table Cell    ${table}    1    1
    ${check_id}=    Get Table Cell    ${table}    ${sum_count_table}    1
    Should Be True    '${check_id_table}' == 'ID'

    Click Element    xpath=//*[@href="Training_Edit?trainingid=${check_id}"]

    Clear Element Text    xpath=//*[@id="t_Hour"]

    # Hour Training
    Input Text    xpath=//*[@id="t_Hour"]    15
    ${hour}=    get value    xpath=//*[@id="t_Hour"]

    Click Submit

    Click My Training
    ${check_hour}=    Get Table Cell    ${table}    ${sum_count_table}    6
    Should Be True    '${hour}:00' == '${check_hour}'

    Sleep    2S
    Capture Element Screenshot    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]    ${pic_directory}15_3_Employees-can-edit-the-Hour-Training.png


# Delete All Test Case

#     Click Logout

#     Wait Until Page Contains    Login to your account
#     Input Text    username    ${admin_login}
#     Input Password    password    1234
#     Click button    id=submit myBtn
    
#     Title Should Be    check in
#     Wait Until Page Contains    Welcome

#     Sleep    2s
#     Click Training Management
#     Click Training Management

#     Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[3]/div/div[1]/div[1]/div/label/select
#     Click Element    xpath=/html/body/div[3]/div[2]/div/div[2]/div[3]/div/div[1]/div[1]/div/label/select/option[4]

#     ${records_val}=    get value    xpath=/html/body/div[3]/div[2]/div/div[2]/div[3]/div/div[1]/div[1]/div/label/select/option[4]
#     Should Be True    '${records_val}' == '-1'

#     # count table
#     ${count_table}=    Get element count    ${table_name}

#     IF    ${count_table} != 1
#         FOR    ${i}    IN RANGE    ${count_table}
#             Click Element    xpath=//*[@id="myTable"]/tbody/tr[${count_table}]/td[8]/a[2]
#             Sleep    2s
#             Press Keys    xpath=//*[@class="confirm btn btn-lg btn-danger"]    ENTER
#             Reload Page
#             ${count_table}    set variable  ${{${count_table} - 1}}
#         END
#     ELSE
#         ${check_text}=    Get Text    xpath=//*[@id="myTable"]/tbody/tr/td
#         Should Be True    '${check_text}' == 'No data available in table'
#     END


    # finish all test case
    Close All Browsers