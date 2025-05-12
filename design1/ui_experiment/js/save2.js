
var v_finaltest = {

    on_start: function(trial){

      if (is_showcorrect_inlog) console.log("Correct answer:",trial,trial.data.correct_response);

    },
    // trial_duration: finaltest_rtlimit_duration,
    type: jsPsychSurveyText,
    question: function(){
      ftlnow=jsPsych.timelineVariable('ftl');
      return([{prompt: "".concat(`Type the whole word you studied in <strong>ALL</strong> previous lists, starting with <strong>"`,ftlnow,`</strong>`,`________<br>"`,"The first word if you remember:")}, {prompt: `The second word if you remember:`}])
    },
    choices: responsekeys_final,
    data:{
      task: 'finalt_response',
      correct_responses: jsPsych.timelineVariable('wordchosen_finaltest'),
      testpos_final: jsPsych.timelineVariable('testpos_final'),
      prespos_iposintrial_test: jsPsych.timelineVariable('prespos_iposintrial_test'),
      testpos_pretest: jsPsych.timelineVariable('testpos_pretest'),
      prespos_iposintrial_study: jsPsych.timelineVariable('prespos_iposintrial_study'),
      // lag: jsPsych.timelineVariable('lag'),
      stimulus_id: jsPsych.timelineVariable('testimg'),
      isold: jsPsych.timelineVariable('isold')
    },
    on_finish: function(data){

      console.log(data.response)
        
      data.correct = jsPsych.pluginAPI.compareKeys(data.response, data.correct_response);
      if (data.correct) tempcrr=1; else tempcrr=0;
      data.recognition_correct = tempcrr;
      
      console.log( data.correct)
      data.accumulated_accuracy = (data.accumulated_accuracy*(data.testpos_pretest-1)+tempcrr)/data.testpos_pretest;

      if (data.response == null & (!is_debug)){
          warningfunc(`<div font-size: larger; font-weight: bold; color: black;"> You need to respond faster!  </div>`,warning_duration)
      }
      if (data.rt < rtfastcut_duration & data.response!=null & (!is_debug)){
          warningfunc(`<div style= "text-align:center" ; font-size: larger; font-weight: bold; color: black; class="center-screen" ><br> <br> <br> <br> <br> Too fast!  </div>`,warning_duration)
      } 
    }
    // post_trial_gap: posgap_duration
  };

  var finaltest_feedback = {
    on_start: function(trial){
      console.log(jsPsych.data.get().last(1).values()[0].correct)
    },
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){
      if (jsPsych.data.get().last(1).values()[0].correct) return "Correct!"
      else return "Incorrect!"
    },
    data:{
      task: 'pretest_feedback'
    },
    post_trial_gap: posgap_duration,
    trial_duration: feedbackmes_wordinitial_duration,
    choices:"NO_KEYS"
  }

  var finaltest_procedure = {
    timeline: [v_finaltest],
    timeline_variables: tot_word_finaltest_arobj,
    on_finish: function(data){
      data.timelasted=Date.now()-lastActivityTime;
    }
  };
  timeline.push(finaltest_procedure)

{  questions: function(){
    ftlnow=jsPsych.timelineVariable('ftl');
    return [{prompt: "".concat(`Type <strong>the whole word</strong> you just studied, starting with <strong>"`,ftlnow,`</strong>`,`________:"`,`<br> Type "none" if you don't remember`),
    required:true,
    placeholder:`type in 'none' or word start with '`.concat(jsPsych.timelineVariable('ftl'),`'`)}]
  }}