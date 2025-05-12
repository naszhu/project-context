var v_test = {
        on_start: function(trial){
            // console.log("current correct rp",trial.data.correct_response);
            if (trial.data.testpos==1 & trial.data.trialnum==1){
                    // var messageDiv = document.createElement("div");
                    // messageDiv.setAttribute("id", "Div1");
                    // messageDiv.innerHTML = "";
                    // messageDiv.style.textAlign = "center";
                    // messageDiv.style.margin = "0px"
                    // messageDiv.style.justifyContent = "center";
                    // document.body.prepend(messageDiv);
                }
            if (trial.data.testpos == 1){
                trial.data.accumulated_accuracy = 0;
                // trial.data.accumulated_accuracy_last = 0;
            }
            else {
                // document.getElementById("Div1").style.visibility = "visible";
                // console.log(jsPsych.data.getLastTrialData())
                trial.data.accumulated_accuracy = jsPsych.data.getLastTrialData().trials[0].accumulated_accuracy;
                // trial.data.accumulated_accuracy_last = jsPsych.data.getLastTrialData().trials[0].accumulated_accuracy
            }
        },
        trial_duration: response_rtlimit_duration,
        type: jsPsychImageKeyboardResponse,
        stimulus: jsPsych.timelineVariable('testimg_dir'),
        choices: responsekeys,
        data:{
          task: 'pretest_response',
          correct_response: jsPsych.timelineVariable('correct_response'),
          isold: jsPsych.timelineVariable('isold'),
          probetype: jsPsych.timelineVariable('probetype'),
          prespos: jsPsych.timelineVariable('prespos'),
          testpos: jsPsych.timelineVariable('testpos'),
          lag: jsPsych.timelineVariable('lag'),
          trialnum: i_trial+1,
          stimulus_id: jsPsych.timelineVariable('testimg')
        //   accuracy_lasttrial: 
        },
        prompt: function(){
            lastresp = jsPsych.data.get().last(1).values()[0]
            console.log(lastresp)
            if (lastresp.task == "pretest_response"){
                return '<p color: black;background: white;><strong>"F" for new&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"J" for old</strong></p>'.concat("Your accumulated accuracy for this trial is: ").concat(Math.round(lastresp.accumulated_accuracy*100)).concat("%")
            }
            else { //first trial
                return '<p color: black;background: white;><strong>"F" for new&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"J" for old</strong></p>'.concat("Your accumulated accuracy for this trial is: ")
            }
        },

        on_finish: function(data){

            data.correct = jsPsych.pluginAPI.compareKeys(data.response, data.correct_response);
            if (data.correct) tempcrr=1; else tempcrr=0;

            data.accumulated_accuracy = (data.accumulated_accuracy*(data.testpos-1)+tempcrr)/data.testpos;
            // console.log("data.accumulated_accuracy_af",data.accumulated_accuracy)

            if (data.response == null){
                // document.getElementById("Div1").style.visibility = "hidden";
                warningfunc("<div font-size: larger; font-weight: bold; color: black;> You need to respond faster!  </div>",warning_duration)
            }
            if (data.rt < rtfastcut_duration & data.response!=null){

                // document.getElementById("Div1").style.visibility = "hidden";
                warningfunc(`<div style= "text-align:center" ; font-size: larger; font-weight: bold; color: black; class="center-screen" ><br> <br> <br> <br> <br> Too fast!  </div>`,warning_duration)
            } else{
                
                // document.getElementById("Div1").style.visibility = "visible";
                if (data.testpos==20){
                    // document.getElementById("Div1").innerHTML = "";
                }
                else{
                    // document.getElementById("Div1").innerHTML = "Your accumulated accuracy for this trial is ".concat(Math.round(data.accumulated_accuracy*100)).concat("%");
                }
            },
    }