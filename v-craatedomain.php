<?php

// Server credentials
$account=$argv[1];
$domainvalue=$argv[2];
$v_hostname = 'PANEL-URL-HERE';
$v_port = '8083';
$v_username = 'admin';
$v_password = 'ADMIN-PASSWORD-HERE';
$v_returncode = 'yes';
$v_command = 'v-add-domain';

// New Domain
$username = $account;
$domain = $domainvalue;

// Prepare POST query
$postvars = array(
    'user' => $v_username,
    'password' => $v_password,
    'returncode' => $v_returncode,
    'cmd' => $v_command,
    'arg1' => $username,
    'arg2' => $domain
);
$postdata = http_build_query($postvars);

// Send POST query via cURL
$postdata = http_build_query($postvars);
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
    $data = "Domain has been successfuly created\n";
} else {
    $data = "Query returned error code: " .$answer. "\n";
}

echo($data);
echo("\n");
?>