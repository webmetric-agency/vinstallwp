<?php
// Server credentials
$account=$argv[1];
$domainvalue=$argv[2];
$v_hostname = 'PANEL-URL-HERE';
$v_port = '8083';
$v_username = 'admin';
$v_password = 'ADMIN-PASSWORD-HERE';
$v_returncode = 'yes';
$v_command = 'v-add-database';
$dbname=$argv[1];
$username=$argv[2];
$pass=$argv[3];

// New Database
$username = $account;
$db_name = $argv[2];
$db_user = $argv[3];
$db_pass = $argv[4];

// Prepare POST query
$postvars = [
    'user' => $v_username,
    'password' => $v_password,
    'returncode' => $v_returncode,
    'cmd' => $v_command,
    'arg1' => $username,
    'arg2' => $db_name,
    'arg3' => $db_user,
    'arg4' => $db_pass
];
$postdata = http_build_query($postvars);

// Send POST query via cURL
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, 'https://' . $v_hostname . ':' . $v_port . '/api/');
curl_setopt($curl, CURLOPT_RETURNTRANSFER,true);
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $postdata);
$answer = curl_exec($curl);

// Check result
if($answer == 0) {
    $data = "Database has been successfuly created\n";
} else {
    $data = "Query returned error code: " .$answer. "\n";
}

echo($data);
echo("\n");
?>