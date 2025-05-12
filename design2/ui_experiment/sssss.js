    var is_debug = true;
    if (is_debug) {
      var num_trials_useddebug = 1;
      var study_duration = 100;
      var prompt_duration = 100;
      var counting_duration = 100;
      var fixation_duration = 100;
      var counting_gap = 0;
      var posgap_duration = 0;
      var rtfastcut_duration = 0;
      var response_rtlimit_duration = 100;
      var responsekeys = "NO_KEYS";
      var finaltest_rtlimit_duration = 100;
    } else{
      var num_trials_useddebug = 10;
      var study_duration = 2000;
      var prompt_duration = 2500;
      var counting_duration = 1000;
      var fixation_duration = 1000;
      var counting_gap = 1000;
      var posgap_duration = 100;
      var rtfastcut_duration = 60;
      var response_rtlimit_duration = 3500; //3.5s to respond each question
      var responsekeys = ['f','j'];
      var finaltest_rtlimit_duration = 4000;
    }
    console.log(fixation_duration)