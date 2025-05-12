    var v_finaltest = {

        on_start: function(trial){
            // if (is_showcorrect_inlog) console.log("Correct answer:",trial,trial.data.correct_response_key);
            if (is_showcorrect_inlog) console.log("Correct answer:",trial.data.correct_response_key);

            if (trial.data.testpos == 1){
                trial.data.accumulated_accuracy = 0;
            }
            else {
                trial.data.accumulated_accuracy = jsPsych.data.get().last(2).values()[0].accumulated_accuracy
            };
            // console.log(jsPsych.data.get())
        },
            trial_duration: finaltest_rtlimit_duration,
            type: jsPsychImageKeyboardResponse,
            stimulus: jsPsych.timelineVariable('id_picDir'),
            choices: responsekeys,
            data:{
                task: 'finalTest',
                current_assignmentTypesWithinList: JT("current_assignmentTypesWithinList"),
                is_chosenFinal: JT("is_chosenFinal"),
                is_currentObjAppear1: JT("is_currentObjAppear1"),
                is_studied_appear0_initial: JT("is_studied_appear0_initial"),
                is_studied_appear1_initial: JT("is_studied_appear1_initial"),
                is_studied_appear2_initial: JT("is_studied_appear2_initial"),
                is_tested_appear0_initial: JT("is_tested_appear0_initial"),
                is_tested_appear1_initial: JT("is_tested_appear1_initial"),
                is_tested_appear2_initial: JT("is_tested_appear2_initial"),
                listNum_appear0_initial:  JT('listNum_appear0_initial'),
                listNum_appear1_initial: JT("listNum_appear1_initial"),
                stimulusConditionName_nPlusOneTrial: JT("stimulusConditionName_nPlusOneTrial"),
                num_CurrObjAppear: JT("num_CurrObjAppear"),
                stimulusConditions: JT("stimulusConditions"),
                studyPos_appear0_initial: JT("studyPos_appear0_initial"),
                studyPos_appear1_initial: JT("studyPos_appear1_initial"),
                studyPos_appear2_initial: JT("studyPos_appear2_initial"),
                testPos_appear0_initial: JT("testPos_appear0_initial"),
                testPos_appear1_initial: JT("testPos_appear1_initial"),
                testPos_appear2_initial: JT("testPos_appear2_initial"),
                testPos_final: JT("testPos_final"),
                type_code_studiedCurr: JT("type_code_studiedCurr"),
                type_code_testiedCurr: JT("type_code_testiedCurr"),
                type_code_testiedNext: JT("type_code_testiedNext"),
                type_comment: JT("type_comment"),
                id_picName: JT("id_picName"),
                is_old: JT("is_old"),
                correct_response_key: JT("correct_response_key"),
                listNum_appear2_initial: JT("listNum_appear2_initial"),
                listNum_pickedFrom: JT("listNum_pickedFrom")
            },
            prompt: function(){
                lastresp = jsPsych.data.get().last(2).values()[0]
                feedbacknow = `<FONT color="white"><p> . </p> <p> . </p></FONT>`
                return '<p color: black;background: white;>"F" for new&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;"J" for old</strong></p>'.concat(`<p><FONT color="white"> . </p><FONT>`)

            
            },
            on_finish: function(data){

                data.correct = jsPsych.pluginAPI.compareKeys(data.response, data.correct_response_key);
                if (data.correct) tempcrr=1; else tempcrr=0;
                data.recognition_correct = tempcrr;

                data.accumulated_accuracy = (data.accumulated_accuracy*(data.testpos-1)+tempcrr)/data.testpos;  

                if (data.response == null & (!is_debug)){
                    warningfunc(`<div font-size: larger; font-weight: bold; color: black;"> You need to respond faster!  </div>`,warning_duration)
                }
                if (data.rt < rtfastcut_duration & data.response!=null & (!is_debug)){
                    warningfunc(`<div style= "text-align:center" ; font-size: larger; font-weight: bold; color: black; class="center-screen" ><br> <br> <br> <br> <br> Too fast!  </div>`,warning_duration)
                };

                // console.log(correctionmap);
                lastobj = correctionmap.get(data.id_picName);
                if (lastobj){

                    if (!lastobj) console.log("Error!!",data.stimulusConditions)
                    data.correct_appear1 = lastobj.correct_appear1;
                    data.correct_appear2 = lastobj.correct_appear2;
                }
            }
            // post_trial_gap: posgap_duration
        };
