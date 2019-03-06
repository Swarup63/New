*** Settings ***
Test Setup        Connect To Database Using Custom Params    cx_Oracle    '${DBUSERNAME}/${DBPASSWORD}@${DBSID}.world'
Test Teardown     Run Keywords    Web Teardown
...               AND    Run Keyword And Ignore Error    Disconnect From Database
Resource          ../../../keywords/common/Common.txt
Resource          ../../../keywords/webClient/Commom.txt
Resource          ../../../keywords/webClient/AX/Debtors_and_Creditors.txt
Resource          ../../../keywords/webClient/AX/Transactions.txt
Variables         ../../variables.py
Library           Selenium2Library
Library           DatabaseLibrary

*** Test Cases ***
AX_Financial Documents RT_BSCS_041
    [Documentation]    AX: Verify if financial documents and financial transactions are correctly generated
    ...
    ...    LSV Regression Tests
    ...    Detailed TC description at QC, Domain FRA project Miami,_Systemtest/Regressiontest/MIAMI_WOW01/Deployment_BSCS
    ...    TC: RT_BSCS_041_AX_financial_documents
    ...
    ...    Test pre-requisites
    ...    -------------------
    ...    None
    ...
    ...    Test scope
    ...    ----------
    ...    Goes to Debtors and Creditors menu
    ...    Financial Overview link
    ...    Check in Financial tab if the documents Financial documents and financial transactions are correctly listed.
    Login Web App    ${AX_URL}    ${AX_USER}    ${AX_PASSWORD}    ${BROWSER}
    ${results}    Query    select OA.customer_id, OA.ohrefnum, CR.CACHKNUM FROM orderhdr_all OA, cashreceipts_all CR WHERE OA.customer_id in (select customer_id from cashreceipts_all where customer_id in (select customer_id from customer_all where business_unit_id=2)) AND CR.CACHKNUM IS NOT NULL AND OA.ohrefnum IS NOT NULL order by customer_id asc
    ${customerID}    Set Variable    ${results[0][0]}
    ${financial_document}    Set Variable    ${results[0][1]}
    ${financial_transaction}    Set Variable    ${results[0][2]}
    ${customerCode}    Query    select custCode from customer_all where customer_id='${customerID}'
    Go to Financial Overview
    Search Debtor/Creditor Financial Overview    ${customerCode[0][0]}
    ${count}    Get Matching Xpath Count    xpath=.//*[@id='content']/h2[contains(text(),'Sorry')]
    Run keyword if    "${count}"=="1"    Run Keywords    Click link    xpath=.//*[@id='kibar']//a
    ...    AND    Click link    xpath=.//*[@id='DebtorAndCreditorsNode_sl']//a[text()='Financial overview']
    Wait Until Element Is Visible    xpath=.//*[@id='Period_From_Field_Documents']    10
    Input Text    xpath=.//*[@id='Period_From_Field_Documents']    Oct 31, 2010
    Click Element    //*[@id='financialOverviewDocumentsContent']//span[@class='DACheckRadioTxt' and text()=' Both']/preceding-sibling::input[1]
    Click Button    xpath=.//*[@id='financialOverviewDocumentsPane_formTag_DOCUMENT_SEARCH_BUTTON']
    Wait Until Page Contains Element    id=CTX_DOCUMENTS_TABLE
    Check if Financial Document exist    ${financial_document}
    Input Text    xpath=.//*[@id='Period_From_Field_Transactions']    Oct 31, 2010
    Click Button    xpath=.//*[@id='financialOverviewDocumentsPane_formTag_TRANSACTIONS_SEARCH_BUTTON']
    Wait Until Page Contains Element    CTX_TRANSACTIONS_TABLE
    Check if Financial Transaction exist    ${financial_transaction}
