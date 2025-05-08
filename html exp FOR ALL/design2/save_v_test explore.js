var v_test = {

    type: jsPsychSurveyText,

    on_start:function(trial){

        is_showcorrect_inlog?console.log(i_trial,JT('wordchosen_initial'),JT('ftl'),JT('wordchosen_finaltest')):null;
        if (is_debug){

            setTimeout(function () {
                jsPsych.finishTrial({
                    response: {
                        question: trial.questions[0].prompt,
                        answer: 'Skipped after ' + (10 / 1000) + ' seconds'
                    },
                    correct: trial.data.word_response == trial.data.wordchosen_initial,
                    is_notremembered: trial.data.word_response == "none",
                    word_response:  ""
                });
            }, 
            10);
        }

    },

    questions: function(){
        ftlnow=JT('ftl');
        return [{
            prompt: "".concat(`Type <strong>the whole word</strong> you just studied, starting with <strong>"`,ftlnow,`</strong>`,`________:"`,`<br> Type "none" if you don't recall`),
            required:true,
            placeholder:``.concat(`type the word starting with '`,JT('ftl'),`' or 'none'`) 
        }] 
    },

    on_load: function(){
      // Define variables
        var trialStartTime = performance.now(); // Record the trial's start time
        console.log(trialStartTime)
        var startTime = null; // Will hold the start time of typing
        var endTime; // Will hold the last keypress time
        var keyPressTimes = []; // Will hold times of each keypress
        
        // Get the input element
        // var input = document.querySelector('#jspsych-survey-text-response-0');
        var input = document.getElementById("input-0");
        console.log(input)

        // Listen for keydown events
        input.addEventListener('keydown', function(e){
            var timeElapsed = performance.now() - trialStartTime; // Time since trial started
            console.log("here",startTime,endTime,keyPressTimes,timeElapsed,e.key)
            // Record start time on the first key press
            if(!startTime & e.key !== "Enter"){
                startTime = timeElapsed;
            }

            // Exclude the Enter key from end time recording
            if(e.key !== "Enter"){
                endTime = timeElapsed;
                keyPressTimes.push(timeElapsed); // Record time of each key press
            }
        });
        // console.log(startTime,endTime,keyPressTimes)
    },

    data:{
        task: 'pretest_response',
        trialnum: i_trial+1,
        ftl: JT('ftl'),
        is_test: JT('is_test'),
        is_test_inpair: JT('is_test_inpair'),
        is_test_inpair1: JT('is_test_inpair1'),
        is_test_inpair2: JT('is_test_inpair2'),
        listgroup_1to5: JT('listgroup_1to5'),
        listnumber_1to10: JT('listnumber_1to10'),
        listnumber_1to10_inpair1 : JT('listnumber_1to10_inpair1'),
        listnumber_1to10_inpair2 : JT('listnumber_1to10_inpair2'),
        pairs_which_1or2: JT('pairs_which_1or2'),
        prespos: JT('prespos'),
        prespos_inpair1: JT('prespos_inpair1'),
        prespos_inpair2: JT('prespos_inpair2'),
        testpos_pretest: JT('testpos_pretest'),
        testpos_final: JT('testpos_final'),
        testpos_inpair: JT('testpos_inpair'), 
        testpos_inpair1: JT('testpos_inpair1'), 
        testpos_inpair2: JT('testpos_inpair2'), 
        word_left_i: JT('word_left_i'),
        word_right_i: JT('word_right_i'),
        wordchosen_initial: JT('wordchosen_initial'),
        wordchosen_finaltest: JT('wordchosen_finaltest'), 
        wordchosen_inpair1: JT('wordchosen_inpair1'), 
        wordchosen_inpair2: JT('wordchosen_inpair2'), 
        wordcondi: JT('wordcondi')
    },
    
    on_finish: function(data){
        console.log(startTime,endTime,keyPressTimes)
        // data.typing_start_time = startTime;
        // data.typing_end_time = endTime;
        // data.key_presses_times = keyPressTimes; // Array of times for each keypress
        
        if (data.response==null){
            word_response="";
            // data.is_tooslow = 1;
        }else{
            word_response = Object.values(data.response);
            // data.is_tooslow= 0;
        }
        // word_response = data.response==null ? "" : Object.values(data.response);
        data.word_response_original =  word_response;
        data.word_response =  word_response.map(iword=>iword.toLowerCase().replace(/\s/g, ''));
        data.word_response_extract =  data.word_response[0];
        data.is_notremembered = data.word_response == "none";
        data.correct = data.word_response == data.wordchosen_initial;
        
        if (data.pairs_which_1or2===2){
            data.is_correct_otherlist = data.word_response == data.wordchosen_finaltest[0]
            // console.log(data.is_correct_otherlist) ok it works
        } else {
            data.is_correct_otherlist = null;
        }

        var currentElement = word_test_arobj_itrial.filter(iobj=>iobj.prespos===JT('prespos'))[0]
        // console.log("now",currentElement)

        // Modify the property of the timeline variable element
        currentElement.is_correct_otherlist = data.is_correct_otherlist;
        // console.log("now2",tot_word_finaltest_arobj.filter(iobj=>(iobj.prespos===JT('prespos'))&&(iobj.listnumber_1to10===JT('listnumber_1to10')))[0])
        // console.log(data.wordchosen_initial,data.correct,data.word_response)

        // console.log(data.key_presses_times,data.typing_start_time,data.typing_end_time,data.rt)
    },

    post_trial_gap: posgap_duration,
};