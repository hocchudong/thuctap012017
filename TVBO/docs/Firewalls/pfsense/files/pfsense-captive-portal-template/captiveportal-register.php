<!-- Captiveportal-register created by James Kennewell for use at the We Are Red Panda LAN Events.
Copyright 2015-2016
ieatbedrock@gmail.com -->

<?php
require_once("functions.inc");
require_once("config.lib.inc");
require_once("auth.inc");
if ($_POST) {
  $a_user = &$config['system']['user'];
  unset($input_errors);
  $pconfig = $_POST;
  /* input validation */
  if ($_POST['username'] == "") {
    $input_errors[] = "The username is required.";
  }
  if ($_POST['password'] == "") {
    $input_errors[] = "The password is required.";
  }
  if (preg_match("/[^a-zA-Z0-9\.\-_]/", $_POST['username'])) {
    $input_errors[] = "The username contains invalid characters.";
  }
  if (strlen($_POST['username']) > 16) {
    $input_errors[] = "The username is longer than 16 characters.";
  }
  if (($_POST['password']) && ($_POST['password'] != $_POST['password2'])) {
    $input_errors[] = "The passwords do not match.";
  }
  /* check the username is unique */
  if (!$input_errors) {
    foreach ($a_user as $userent) {
      if ($userent['name'] == $_POST['username']) {
        $input_errors[] = "Another entry with the same username already exists.";
        break;
      }
    }
  }
  /* ... and that it's not reserved */
  if (!$input_errors) {
    $system_users = explode("\n", file_get_contents("/etc/passwd"));
    foreach ($system_users as $s_user) {
      $ent = explode(":", $s_user);
      if ($ent[0] == $_POST['username']) {
        $input_errors[] = "That username is reserved by the system.";
        break;
      }
    }
  }
  /* save it */
  if (!$input_errors) {
    $userent = array();
    if ($_POST['password']) {
      local_user_set_password($userent, $_POST['password']);
    }
    $userent['uid'] = $config['system']['nextuid']++;
    $userent['name'] = $_POST['username'];
    $userent['descr'] = $_POST['fullname'];
    $userent['expires'] = "";
    conf_mount_rw();
    /* add the user to "All Users" group */
    foreach ($config['system']['group'] as $gidx => $group) {
      if ($group['name'] == "all") {
        if (!is_array($config['system']['group'][$gidx]['member']))
          $config['system']['group'][$gidx]['member'] = array();
        $config['system']['group'][$gidx]['member'][] = $userent['uid'];
        break;
      }
    }
    $a_user[] = $userent;
    local_user_set_groups($userent, array("warplan")); // <- Remove this line if you don't want / have a "warplan" group
    local_user_set($userent);
    write_config();
    conf_mount_ro();
    $done = true;
  }
}
?>

<html lang="en">
<head>
  <meta charset="utf-8">
  <link rel="shortcut icon" href="captiveportal-favicon.ico" />
  <title>WARP LAN Admin Tool - User Registration</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="captiveportal-bootstrap.min.css" rel="stylesheet">
  <style type="text/css">
    body {
      background: url(captiveportal-back.png);
      background-color: #444;
      background: url(captiveportal-pinlayer2.png),url(captiveportal-pinlayer1.png),url(captiveportal-back.png);    
    }
    .vertical-offset-100 {
      padding-top:100px;
    }    
  </style>
  <script src="captiveportal-jquery-1.11.1.min.js"></script>
  <script src="captiveportal-bootstrap.min.js"></script>
</head>
<body>
<?php if (isset($done)) { ?>
<br/>
Your registration is processed. You now can login <a href="/">here</a>.

<?php } else {
  if ($input_errors) {
    echo "Error <br/>";
    foreach ($input_errors  as $input_error) {
      echo $input_error . "<br>";
    }
  }
?>
  <script src="captiveportal-tweenlite.min.js"></script>

  <div class="container">
    <div class="row vertical-offset-100">
      <div class="col-md-6 col-md-offset-3">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title">WARP LAN Admin Tool - User Registration</h3>
          </div>
          <div class="panel-body">
            <form method="post" action="$PORTAL_ACTION$" accept-charset="UTF-8" role="form">
              <fieldset>
                <!-- Required input boxes for portal page to work. Only required if user authentication is needed. -->
                <p>This form is for the use of WARP Admins to register users for internet access.</p>
                <div class="form-group">
                  <input name="auth_user" type="text" placeholder="Username" class="form-control">
                <input name="auth_pass" type="password" placeholder="Password" class="form-control" >
				<input type="password" name="password2" placeholder="Confirm Password" id="txt_pwd2" class="form-control" >
				<input type="text" name="fullname" placeholder="Full Name" id="txt_name" class="form-control">
                </div>
                
                <input name="redirurl" type="hidden" value="captiveportal-success.html">
                <input class="btn btn-lg btn-success btn-block" name="btn_submit" id="btn_submit" type="submit" value="Register User">
              </fieldset>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div><script type="text/javascript">
  $(document).ready(function(){
    $(document).mousemove(function(e){
     TweenLite.to($('body'), 
      .5, 
      { css: 
        {
          backgroundPosition: ""+ parseInt(event.pageX/8) + "px "+parseInt(event.pageY/'12')+"px, "+parseInt(event.pageX/'15')+"px "+parseInt(event.pageY/'15')+"px, "+parseInt(event.pageX/'30')+"px "+parseInt(event.pageY/'30')+"px"
        }
      });
   });
  });</script>
  <?php } ?>
</body>
</html>
