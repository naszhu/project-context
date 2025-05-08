
/*****************************************************************************************************************
 * Author: Shuchun (Lea) Lai
 * Date: 2023-12-23
 *
 * Description: .code version 3, test of 8 list, 
 * testing 3 participant each at first for pilot
 * Intiially, I forgot to change "num_tottest_finaltest" variable to 120, which made 
 * the first 3 particpant not going to completion code page. 
 * but others should be fine
 * ...
 ****************************************************************************************************************/



    word_left_file= "https://raw.githubusercontent.com/Shu-Lea-Lai/project-visualmemory-sideexp/master/word_left";
    word_right_file= "https://raw.githubusercontent.com/Shu-Lea-Lai/project-visualmemory-sideexp/master/word_right";
    word_left=readTextFile(word_left_file).replace(/\r/g, '').split('\n').slice(0,150);
    word_right=readTextFile(word_right_file).replace(/\r/g, '').split('\n').slice(0,150);
    JT = x=>jsPsych.timelineVariable(x);
    JRR = (x,y)=>jsPsych.randomization.repeat(x,y);


    //****************************************************
    //                    Functions and const
    //****************************************************
    //
    // Brief description of this section and its purpose.
    // Additional details or important information.
    // List of key tasks or functions performed here.
    //
    //****************************************************

///////////////////////////////
    const confirmid = `https://app.prolific.com/submissions/complete?cc=CU7D7U04`;
    var is_debug = false;
    const is_inst_fullscreen = true;
    const is_showcorrect_inlog = false; //
    const timeout_inmin = 100; //100 minutes
    const num_tottest_finaltest = 120;
    const codeversion_begins = 3;
    // const inactivityTimeout = 60*1000*0.1; // Set your desired timeout in milliseconds (e.g., 5 minutes)
    // const notificationTimeout = 60*1000*5; // Set the time for the notification in milliseconds (e.g., another 5 minutes)
    const timeout = 1000 * 60 * timeout_inmin ; // 70 minutes in milliseconds
    // const timeout = 10;
    const condi = "b";//f, b, r
    const finalfeedback_duration = 500;
    var num_trials_useddebug = 1;//number of tirals show in intial test
    let lastActivityTime = Date.now();
    
    document.body.style.backgroundColor = "white";
    var styleElement = document.createElement('style');
    
    // Set the CSS rules
    var cssRules = `
      /* Hide the Continue button */
      .jspsych-btn {
        display: none !important;
        margin: 0 auto;
      }
    
      .jspsych-html-button-response-button .jspsych-btn {
        display: block !important; /* or 'inline-block', 'flex', etc. */
      }
    `;
    
    // Append the CSS rules to the style element
    styleElement.appendChild(document.createTextNode(cssRules));
    
    // Append the style element to the document head
    document.head.appendChild(styleElement);

    let textFile2 = 'https://raw.githubusercontent.com/Shu-Lea-Lai/project-visualmemory-sideexp/master/ps2.txt';

    let oldids = readTextFile(textFile2).replace(/\r/g, '').split('\n');
    console.log(oldids)
    
    function endTrialAfterDuration() {
      jsPsych.finishTrial();
    }
    const trialDurationLimit = 1000;


  
    //****************************************************
    //                    Initialization
    //****************************************************
    //
    // Brief description of this section and its purpose.
    // Additional details or important information.
    // List of key tasks or functions performed here.
    //
    //****************************************************
    var jsPsych = initJsPsych({
        on_trial_finish: function(data){
            jsPsych.data.get().addToLast({timepassed_mins: ((Date.now()-lastActivityTime)/1000/60).toFixed(2) });//adding passed time
            if (jsPsych.data.get().last(1).trials[0].testpos_final==num_tottest_finaltest) {
                jsPsych.data.addProperties({
                    is_finished: 1
            })};
            data.width =  window.innerWidth;
            data.height = window.innerHeight;
        },
        on_finish: function() {

            lasttestpos = jsPsych.data.get().select("testpos_final").values;
            console.log(lasttestpos)
            if (lasttestpos[lasttestpos.length-1]==num_tottest_finaltest) {
                console.log("sucess!!")
                window.location = confirmid;
                }
            }
        // on_start: function(){
        //   jsPsych.pluginAPI.requestFullscreen();
        // }
    });

    //code version 4: change final test instruction and key press

    var timeline = [];
    // jsPsych.data.get().addToAll({condition: condi});
    var subject_id = jsPsych.data.getURLVariable('PROLIFIC_PID');
    var study_id = jsPsych.data.getURLVariable('STUDY_ID');
    var session_id = jsPsych.data.getURLVariable('SESSION_ID');
    
    
    // var condition = condi;

    startExperimentTimer()
    // startInactivityCheck()

    jsPsych.data.addProperties({
      subject_id: subject_id,
      study_id: study_id,
      session_id: session_id,
      condition: condi,
      is_finished: 0,
      codeversion: codeversion_begins, 
      is_changedfullscreen: 0, 
      designversion:2
    });

    
    if (is_debug) {
      var study_duration = 10;
      var prompt_duration = 10;
      var prompt_finaltestlist_duration = 10;
      var counting_duration = 10;
      var fixation_duration = 10;
      var counting_gap = 0;
      var posgap_duration = 0;
      var rtfastcut_duration = 0;
      var response_rtlimit_duration = 10;
      var responsekeys = "NO_KEYS";
      var choiceenter = "NO_KEYS";
      var responsekeys_final = "NO_KEYS";
      var instruction_duration = 10; //1 hour 
      var instruction_duration_between = 10;//10 minutes   
      var finaltest_rtlimit_duration = 10;
      var warning_duration = 10;
      var feedbackmes_duration = 10;
      var feedbackmes_wordinitial_duration = 5; 
      var feedbackmes_wordfinal_duration = 5; 
      var keychoice_finaltest = "NO_KEYS";
    } else{
      var study_duration = 2000;
      var prompt_duration = 2000;
      var prompt_finaltestlist_duration = 2000;
      var counting_duration = 2000;
      var counting_gap = 1000;
      var fixation_duration = 1000;
      var posgap_duration = 100;
      var rtfastcut_duration = 150;
      var response_rtlimit_duration = 3500; //3.5s to respond each question
      var responsekeys = ['f','j'];
      var choiceenter = 'enter';
      var responsekeys_final = ['s','f','j','l'];
      var instruction_duration = 1000*60*60; //1 hour
      var instruction_duration_between = 10*60*60;//10 minutes   
      var finaltest_rtlimit_duration = 4000;
      var warning_duration = 1500;
      var feedbackmes_duration = 2000; 
      var feedbackmes_wordinitial_duration = 600; 
      var feedbackmes_wordfinal_duration = 2000; 
      var keychoice_finaltest = 'enter';
    }
    // console.log(fixation_duration)
    const num_listtotest = 8;//changed
    const numlists = 10;
    const num_pairlists_usedinFinal = num_listtotest/2;
    const ntf = 15;//number test in final test in each list
    const numstudy_inlists = 20;
    const num_digits_pres = 8; // present n digits each trial to fill 24s
    const numword_tot = 150; //number of word pairs in my txt 
    const num_repeatorunique_inlist = 10;
    const num_repeat_tests = 3//[1,1,1,0,0,0,0,0,0,0];
    const num_unique_tests = 5//[1,1,1,1,1,0,0,0,0,0];
    const num_item_tests = num_repeat_tests+num_unique_tests;
    const num_words_eachpair = 30; //e.g., 30 words in list 1&2, 20 for unique and 10 for repeat
    const repeat_tests_array = [...repeatedArray(1,num_repeat_tests),...repeatedArray(0,num_repeatorunique_inlist-num_repeat_tests)];
    const unique_tests_array = [...repeatedArray(1,num_unique_tests),...repeatedArray(0,num_repeatorunique_inlist-num_unique_tests)];
    // console.log(repeat_tests_array,unique_tests_array)
    const tot_digit_list_nf = range(0,numlists).map(i=>jsPsych.randomization.sampleWithReplacement(range(4,10),num_digits_pres)); //create nf easier for final test algorithm coding
    const tot_digit_list = tot_digit_list_nf.flat();
    const tot_correct_sum = range(0,numlists).map(i=>arrsum(tot_digit_list.slice(i*num_digits_pres,(i+1)*num_digits_pres)));
    // word_left
    // word_right
    // word_unique
    word_pairs_arobj_all = range(0,numword_tot).map(i=> {
      left=word_left[i];
      right=word_right[i];
      left_ftl=left.slice(0,2);//first two letters of left
      right_ftl=right.slice(0,2); // first two letters of right
      if (left_ftl!=right_ftl) return (console.log("ERROR!!!!!!"))

      return({
        word_left_i: left,
        word_right_i:right,
        iword: i,
        first_tl_left: left_ftl,
        first_tl_right: right_ftl,
        issame: left_ftl===right_ftl
      })
    }
    )
    

    word_pairs_arobj_all_rand = JRR(word_pairs_arobj_all, 1);

    for (let i_list=0;i_list<word_pairs_arobj_all_rand.length; i_list++){
      i_wordobj = word_pairs_arobj_all_rand[i_list];
      i_wordpairs = jsPsych.randomization.sampleWithoutReplacement([i_wordobj.word_left_i,i_wordobj.word_right_i], 2)
      i_wordobj.word_left_i=i_wordpairs[0];
      i_wordobj.word_right_i=i_wordpairs[1];
    }; // this randomize left and right order
    // console.log(word_pairs_arobj_all_rand)


//****************************************************
//                    Assign tot_word_arobj_nf
//10 of 20 length arr
//Assign AROBJ for all
//****************************************************
    ///////////////////////
    var ftl_RPtested_list_i_pairs1 = [];
    var ftl_RPtested_list_i_pairs2 = [];
    const tot_word_arobj_nf = range(0,numlists).map(i_list=>{

      inum_pairlists_usedinFinal = Math.floor(i_list/2);//0,1,2,3,4,5
      word_pairs_arobj_i = word_pairs_arobj_all_rand.slice(inum_pairlists_usedinFinal*num_words_eachpair,num_words_eachpair+inum_pairlists_usedinFinal*num_words_eachpair);
      new_word_arobj=copyarobj(word_pairs_arobj_i);//copy arobject
      
      //30 pairs used in each list, 10 for repeats, 10+10 for double unique list; List 1,2 share exactly same word_pairs_arobj_i  

      pairs_which_1or2 = i_list % 2 +1 //0 or 1 + 1=1,2 
      
      // word_pairs_RP_arobj_i = new_word_arobj.slice(0,10);      
      test_which_PR = JRR(repeat_tests_array,1);//test three repeats for each list pair
      test_which_nPR = JRR(unique_tests_array,1);//test five nonrepeats for each list pair
      testpos_pre_rd = JRR(range(1,1+num_repeat_tests+num_unique_tests),1);//test 8 item, randomize test position

      numwords_each = Number.isInteger(num_words_eachpair/3) ? num_words_eachpair/3 : console.oog("ERROR!!!")
      console.log(numwords_each)

      if (pairs_which_1or2==1){//if odd
        word_pairs_nRP_arobj_i = new_word_arobj.slice(numwords_each,numwords_each*2);//10-30
      } else{//else
        word_pairs_nRP_arobj_i = new_word_arobj.slice(numwords_each*2,numwords_each*3);//20-30
      }
      word_pairs_RP_arobj_i = copyarobj(new_word_arobj.slice(0,numwords_each));//repeated, take first 10 0-10

      var itest = 0
      var ftl_RPtested_list_i_paris_1or2 = [];
      for (let irp=0;irp<10;irp++){//20 tests, but only iterate 10 becuase 10 repeats 10 unqiue

          wordobj_nPR_i = word_pairs_nRP_arobj_i[irp];
          wordobj_RP_i = word_pairs_RP_arobj_i[irp];

          // assign wordchosen_initial, and ftl
          wordobj_nPR_i.wordchosen_initial=wordobj_nPR_i.word_left_i;
          if (pairs_which_1or2==1) {
            wordobj_RP_i.wordchosen_initial=wordobj_RP_i.word_left_i;
          }
          else wordobj_RP_i.wordchosen_initial=wordobj_RP_i.word_right_i;
          wordobj_RP_i.ftl=wordobj_RP_i.wordchosen_initial.slice(0,2);
          wordobj_nPR_i.ftl=wordobj_nPR_i.wordchosen_initial.slice(0,2);

          //assign test position and which to be tested
          if (test_which_PR[irp]==1) {
            wordobj_RP_i.is_test = 1;
            wordobj_RP_i.testpos_pretest = testpos_pre_rd[itest];
            ftl_RPtested_list_i_paris_1or2.push(wordobj_RP_i.ftl);
            itest++;
          }
          else {
            wordobj_RP_i.is_test = 0;
            wordobj_RP_i.testpos_pretest = 0;
          }

          if (test_which_nPR[irp]==1) {
            wordobj_nPR_i.is_test = 1;
            wordobj_nPR_i.testpos_pretest = testpos_pre_rd[itest];
            itest++;
          }else{
            wordobj_nPR_i.is_test = 0;
            wordobj_nPR_i.testpos_pretest = 0;
          }
          wordobj_RP_i.wordcondi="repeat";
          wordobj_nPR_i.wordcondi="unique";

        }// end iteration of 1-10
    
      if (pairs_which_1or2==1) ftl_RPtested_list_i_pairs1.push(ftl_RPtested_list_i_paris_1or2);
      else ftl_RPtested_list_i_pairs2.push(ftl_RPtested_list_i_paris_1or2);
      

      word_pairs_arobj_i = word_pairs_RP_arobj_i.concat(word_pairs_nRP_arobj_i);
      for (let ii=0;ii<20;ii++){
        word_pairs_arobj_i[ii].pairs_which_1or2=pairs_which_1or2;
        word_pairs_arobj_i[ii].listnumber_1to10 = i_list+1;
        word_pairs_arobj_i[ii].listgroup_1to5 = inum_pairlists_usedinFinal+1;//1-5
        
      }
      // console.log(word_pairs_arobj_i)

      return(word_pairs_arobj_i);
    }) ;//end iteration 1-10; end assigning the nf_arobj. 10 foils per trial, get tot_word_arobj_nf

    



    //assign randomized nfarobj 
    const tot_word_arobj_nf_rd = randomize_ar_inside_nfar(tot_word_arobj_nf);
    range(0,numlists).map(i=>{
      range(0,numstudy_inlists).map(j=>{
      tot_word_arobj_nf_rd[i][j].prespos=j+1;//assign present position to item
    })})
    
    


    //****************************************************
    //                    Assign tot_word_arobj the corrsponding features
    //****************************************************
    for (let i_list=0;i_list<10;i_list++){
        
        // console.log(i_list)
        if_pair1 = i_list%2===0&&true;//0,2,4,6,8
        inum_pairlists_usedinFinal = Math.floor(i_list/2);//0,1,2,3,4
        if (if_pair1) {var j_final=0;}
        // console.log(if_pair1, i_list, j_final)
        
        const arobj_current = tot_word_arobj_nf_rd[i_list];
        const arobj_pair = tot_word_arobj_nf_rd[if_pair1 ? i_list + 1 : i_list - 1];
        
        for (let j=0;j<20;j++){
            
            obj_current = arobj_current[j];
            ftl_oppos_indexinpair = range(0,20).map(inow=>arobj_pair[inow].ftl).findIndex(x=>x==obj_current.ftl); // for each 1, find index in array 2
            
            if (obj_current.wordcondi=="repeat"){
                correspond_obj_inpair = arobj_pair[ftl_oppos_indexinpair];
                obj_current.is_test_inpair = correspond_obj_inpair.is_test==1? 1 : 0;

                obj_current.testpos_inpair=correspond_obj_inpair.testpos_pretest;
                obj_current.prespos_inpair=correspond_obj_inpair.prespos;
                
                if (if_pair1) {//pair1 and pair2 always by word_left and right order
                    pair1 = obj_current;
                    pair2 = correspond_obj_inpair;
                } else {
                    pair1 = correspond_obj_inpair;
                    pair2 = obj_current;
                }
                
                
                obj_current.wordchosen_inpair1 = pair1.word_left_i;
                obj_current.wordchosen_inpair2 = pair1.word_right_i;
                obj_current.prespos_inpair1 = pair1.prespos;
                obj_current.prespos_inpair2 = pair2.prespos;
                obj_current.testpos_inpair1 = pair1.testpos_pretest;
                obj_current.testpos_inpair2 = pair2.testpos_pretest;
                obj_current.listnumber_1to10_inpair1 = pair1.listnumber_1to10;
                obj_current.listnumber_1to10_inpair2 = pair2.listnumber_1to10;
                obj_current.is_test_inpair1 = pair1.is_test;
                obj_current.is_test_inpair2 = pair2.is_test;
                obj_current.wordchosen_finaltest = [pair1.word_left_i,pair1.word_right_i];
                
                
                
            } else if(obj_current.wordcondi=="unique"){
                
                obj_current.is_test_inpair =null;
                obj_current.testpos_inpair  =null;
                obj_current.prespos_inpair1=null;
                obj_current.prespos_inpair2=null;
                obj_current.wordchosen_inpair1 =null;
                obj_current.wordchosen_inpair2 =null;
                obj_current.testpos_inpair1  =null;
                obj_current.testpos_inpair2  =null;
                
                obj_current.listnumber_1to10_inpair1  =null;
                obj_current.listnumber_1to10_inpair2  =null;
                obj_current.is_test_inpair1  =null;
                obj_current.is_test_inpair2  =null;
                
                obj_current.wordchosen_finaltest = [obj_current.wordchosen_initial];
            }
        }
        // console.log(j_final)
    }

    
    const tot_word_arobj_nf_rd_slice = tot_word_arobj_nf_rd.slice(0,num_listtotest);

    // console.log("nowwwww",tot_word_arobj_nf_rd_slice)

    //****************************************************
    //                    Assign final test position
    //****************************************************
    //  for tot_word_arobj_nf_rd_slice 
    //  add element testpos_final in object
    //****************************************************


    const forward_final_ind = range(0,num_pairlists_usedinFinal).map(i=>[].concat(JRR(range(i*ntf+ntf*i+1,i*ntf+ntf+ntf*i+1),1),JRR(range(i*ntf+ntf+ntf*i+1,i*ntf+ntf+ntf+ntf*i+1),1)));
    const backward_final_ind = range(0,num_pairlists_usedinFinal).reverse().map(i=>[].concat(JRR(range(i*ntf+ntf*i+1,i*ntf+ntf+ntf*i+1),1),JRR(range(i*ntf+ntf+ntf*i+1,i*ntf+ntf+ntf+ntf*i+1),1)));
    const randind = JRR(range(1,ntf*2*num_pairlists_usedinFinal+1),1);
    const random_final_ind = range(0,num_pairlists_usedinFinal).map(i=>randind.slice(i*ntf*2,ntf*2*i+ntf*2));
    console.log("forward,backward, and randomind",forward_final_ind,backward_final_ind,random_final_ind)

    const which_test_RP = range(0,num_pairlists_usedinFinal).map(i=>JRR([1,1,1,1,1,0,0,0,0,0],1));//test 5 repeats in 1 and 5 repeats in 2


    if (condi=="f") finalt_ind = forward_final_ind;
    else if (condi=="b") finalt_ind = backward_final_ind;
    else if (condi=="r") finalt_ind = random_final_ind;
    // finalt_ind = finalt_ind.flat();
    console.log(finalt_ind)

    var nonRepeatedListgroup = [];
    var whichgroupfirst = [];
    var testedFTL=[];
    var jtest = 0;
    var jtestingroup1=0
    arraytoAssignFinalTestpos = condi=='b'?[...tot_word_arobj_nf_rd_slice].reverse() :tot_word_arobj_nf_rd_slice; 

    //****************************************************
    //                    Add final test position in total objects
    //****************************************************
    arraytoAssignFinalTestpos.forEach(function(listarr,ilist){
    listarr.forEach(function(obj,iobj){

        var listgroup = obj.listgroup_1to5-1;

        if (!nonRepeatedListgroup.includes(listgroup)){

        //stuff to add when pair number updated (1-5), i.e., first encounter of list in group
        nonRepeatedListgroup.push(listgroup);
        whichgroupfirst.push(obj.listnumber_1to10);
        jtestingroup1=0; //0-9 counts for items in repeat condition in each first encounter in a list group  
        jtest=0;//0-29, test position in each listgorup
        firstinpair=1;
        
        // console.log(listgroup,nonRepeatedListgroup)
        
        // var pairsAlready={}; 
        } else{
        firstinpair=0;
        }
        // console.log("sss",obj.listnumber_1to10,firstinpair)

        if (whichgroupfirst.includes(obj.listnumber_1to10)){
        firstinpair=1;
        }
        else {
        firstinpair=0;
        jtestingroup1=null;
        }
        // console.log("firstinpair",whichgroupfirst,firstinpair)
        // console.log("firstinpair",firstinpair)
        
        if (obj.wordcondi==="unique"){
        obj.testpos_final = finalt_ind[listgroup][jtest];
        obj.is_chosenfinaltest = 1;
        jtest++;
        } else if (obj.wordcondi==="repeat"){
        
        //in first in pair -- by pre-assigned testing condition;
        //  in second in pair -- not tested already
        // console.log("must up to 9", jtestingroup1)
        truecondition = (which_test_RP[listgroup][jtestingroup1] && firstinpair===1) || (firstinpair==0 && !testedFTL.includes(obj.ftl))

        if (firstinpair===1) jtestingroup1++

        if (truecondition){//if true above

            obj.testpos_final = finalt_ind[listgroup][jtest];
            correspondObj=tot_word_arobj_nf_rd_slice.flat().find(nowobj=>((nowobj.ftl===obj.ftl)&&(nowobj.listnumber_1to10!=obj.listnumber_1to10)));//find corresponding obj
            correspondObj.testpos_final=finalt_ind[listgroup][jtest];
            obj.is_chosenfinaltest = 1;
            correspondObj.is_chosenfinaltest = 0;
            testedFTL.push(obj.ftl);
            jtest++;
            // console.log("must up to 29", jtest)
        }
        }
    })
    })






    console.log("arobj before random_nonslice",tot_word_arobj_nf)
    console.log("arobj after random_nonslice",tot_word_arobj_nf_rd)
    console.log("arobj after random_sliced",tot_word_arobj_nf_rd_slice)
    console.log("testpos_final all extracted",range(0,tot_word_arobj_nf_rd_slice.flat().length).map(i=>{

    if (tot_word_arobj_nf_rd_slice.flat()[i].testpos_final==undefined) console.log(tot_word_arobj_nf_rd_slice.flat()[i])
    return tot_word_arobj_nf_rd_slice.flat()[i].testpos_final
    }))


    //****************************************************
    //                   Assign intial test TEST varibale (tot_word_test_arobj_nf)
    //****************************************************
    // Getting arobj for tests (excluding study) for intial tests 
    // assign initial test arobj_nf, adding test poisition 
    // 
    // 
    //
    //****************************************************


    const tot_word_test_arobj_nf = range(0,num_listtotest).map(i=>{

    testposarr_ilist = range(0,numstudy_inlists).map(j=>tot_word_arobj_nf_rd_slice[i][j].testpos_pretest);
    
    index = range(0,num_item_tests).map(j=>{//8 test item, 3+5
        return testposarr_ilist.findIndex(x=>x==j+1)
    })
    // console.log(testposarr_ilist,index)
    word_iobj = tot_word_arobj_nf_rd_slice[i];
    return (range(0,num_item_tests).map(j=>word_iobj[index[j]]))

    })
    console.log("test_initial",tot_word_test_arobj_nf)


    //****************************************************
    //                   Finaltest variable (tot_word_test_arobj_nf)
    //****************************************************
    //
    //
    //****************************************************
    //assign final test arobj_nf 
    const tot_word_finaltest_arobj = tot_word_arobj_nf_rd_slice.map(arr=>arr.filter(obj=> obj.is_chosenfinaltest === 1)).flat().sort((a,b)=>a.testpos_final-b.testpos_final)
    console.log("finaltest - tot_word_finaltest_arobj",tot_word_finaltest_arobj);


    //****************************************************
    //                    The following assign mark to every changed, only insert the mark when condition is not random
    // "listnumberChange": This is for usage of adding prompt of final test  
    //****************************************************
    // const keyForDigit = 'digit';

    if (condi!='r'){
        for (let i = 1; i < tot_word_finaltest_arobj.length; i++) {
            const currentObj = tot_word_finaltest_arobj[i];
            const previousObj = tot_word_finaltest_arobj[i - 1];
            // console.log("ssssssssss")
            if (currentObj.listnumber_1to10 !== previousObj.listnumber_1to10) {
                // Change detected, mark the current object
                // console.log("ssssssssss")
                currentObj.listnumberChange = true;
            } else {
                currentObj.listnumberChange = false;
            }
        }
    }

    // The first object doesn't have a previous one to compare with, so it's marked as a change
    tot_word_finaltest_arobj[0].listnumberChange = true;
    // console.log(tot_word_finaltest_arobj.map(i=>[i.listnumber_1to10,i.wordcondi]))
    console.log(tot_word_finaltest_arobj.filter(i=>i.wordcondi==="repeat").map(i=>[i.listnumber_1to10,i.wordcondi,i.testpos_final,i.prespos]))


    //********************************************************************************************************
    //                    Experiment variables - experiment start now
    //********************************************************************************************************
    //
    // .
    //.
    // 
    //
    //********************************************************************************************************
    var enter_fullscreen = {
    // type: jsPsychFullscreen,
    // fullscreen_mode: true
    
        type: jsPsychFullscreen,
        fullscreen_mode: true,
        message: `To start the experiment, please enter fullscreen mode.  <p>You should not exit fullscreen until you finish the experiment. </p> <br><br>Press 'enter' to continue`,
        on_load:function(){
            document.addEventListener('keydown', function (event) {
            // Check if the pressed key is Enter (key code 13)
            if (event.key === 'Enter') {
                // Simulate a click event on the hidden "Continue" button
                var continueButton = document.getElementById('jspsych-fullscreen-btn');
                // console.log(continueButton)
                if (continueButton) continueButton.click();
            }
        });
        }
    }

    var handleFullscreenChange = true;
    is_inst_fullscreen? 
    document.addEventListener('fullscreenchange', function(event) {
        if (handleFullscreenChange&&!document.fullscreenElement) {
            // Handle the case when the user exits fullscreen during the experiment
            // jsPsych.enterFullscreen(); // Re-enter fullscreen
            alert('Please keep the experiment in fullscreen mode. Press F11. Or your data might not be valid');
            jsPsych.data.addProperties({
                is_changedfullscreen: 1
            });
            // timeline.push(enter_fullscreen)
        }
    }) : null;


    is_inst_fullscreen? window.onbeforeunload = function() {
    return "Do you really want to leave?";
    //if we return nothing here (just calling return;) then there will be no pop-up question at all
    //return;
    } : null;

    var browser_check = {
    type: jsPsychBrowserCheck,
    on_finish: function(data){
        // window.onbeforeunload = null;
        console.log(data.browser)
        if (!(["chrome","Chrome"].includes(data.browser))){
        // console.log(data.browser)
            alert("You must use Chrome as your browser! You may switch your browser and come back later.")
            window.onbeforeunload = null;
            window.location="https://www.google.com"
            window.close = true
        } else if (data.mobie){
            alert("You must use a desktop/laptop computer to participate in this experiment.")
            window.onbeforeunload = null;
            window.location="https://www.google.com"
            window.close = true
        }
    }
        
    };


    var enterid = {
    type: jsPsychSurveyText,
    questions: [{prompt: "<p color:black>What is your prolific ID?</p> <p> Press 'enter' to continue after filling in your ID.",required:true}],
    on_load:function(){
        var continueButton = document.getElementById('jspsych-survey-text-next');
        if (continueButton) continueButton.style.display='block !important'
        console.log(continueButton)
    },
    on_finish:function(data){
        data.id=data.response["Q0"];
        // console.log("wwwww")
        if (oldids.includes(data.id)) {
            alert(`
            Dear participant,
            
            We have identified that you have previously taken part in one of our research studies, and we sincerely value your prior involvement. Regrettably, we must inform you that you are ineligible to participate in the current study once more.
            
            If you believe this determination to be in error, please do not hesitate to reach out to our research team. We will promptly address your concerns.
            
            Thank you for your understanding.
            `);
            console.log("true")
            window.onbeforeunload = null;
            window.location="https://www.google.com"
            window.close = true
            jsPsych.endExperiment();
        }
    },
    data: {
        task: "enterid"
    }
    }


    // is_inst_fullscreen? timeline.push(enterid) : null; 
    // 


    var fixation = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: "NO_KEYS",
        trial_duration: fixation_duration,
        data: {
            task: 'fixation'
        }
    };

    var instructions = {
        type: jsPsychSurveyMultiChoice,
        on_load:function(){
        // var continueButton = document.getElementById('jspsych-fullscreen-btn');
        // if (continueButton) continueButton.style.display='block'
        // console.log(continueButton)
        },
        questions: [
        {
        prompt: `<h1 style='text-align: left;color: crimson;background: white;font: caption-;''> INDIANA UNIVERSITY STUDY INFORMATION SHEET FOR RESEARCH MEMORY TEST FOR WORD AND PICTURE </h1> <br>

            <h1 style='color: black;text-align: left;background: white;font: caption;'> You are being asked to participate in a research study. Scientists do research to answer important questions that might help change or improve the way we do things in the future. This document will give you information about the study to help you decide whether you want to participate. Please read this form, and ask any questions you have, before agreeing to be in the study. This study is being conducted under the approval of the Indiana University Institutional Review Board (IRB) with protocol number 18431, including any approved amendments.</h1><br>

            <h1 style='color: black;text-align: left;background: white;font: caption;'> All research is voluntary. You can choose not to take part in this study. If  you decide to participate, you can change your mind later and leave the study at any time. You will not be penalized or lose any benefits if you decide not to participate or choose to leave the study later.</h1> <br> 

            <h1 style='color: black;text-align: left;background: white;font: caption;'> This research is intended for individuals 18 years of age or older. If you are under age 18, do not complete the survey. This research is for residents of the United States. If you are not a U.S. resident, do not complete the survey.</h1> <br> 

            <h1 style='color: black;text-align: left;background: white;font: caption;'> The purpose of this study is to investigate how people remember words and/or pictures.</h1> <br> <h1 style='color: black;text-align: left;background: white;font: caption;'> We are asking you if you want to be in this study because you registered for this study on Prolific. The study is being conducted by Dr. Richard Shiffrin, a professor in the department of Psychological and Brain Science and the Program in Cognitive Science.</h1> <br> 


            
            <h1 style='color: black;text-align: left;background: white;font: caption;'> To protect against loss of confidentiality, any identifiable information from the data that could lead back to you will be removed within two days of your completion of the study.We don’t think you will have any personal benefits from taking part in this study, but we hope to learn things that will help researchers in the future.
            </h1> <br> 
            
            <h1 style='color: black;text-align: left;background: white;font: caption;'><strong><FONT color='#CC5500'> You will be paid for participating in this study.</FONT>We pay at an hourly rate of $10.50, and the payment will be disbursed within 5 days after completing the experiment, there is no cost to participate in this study.<strong> <br><FONT COLOR="#CC5500"> TO BE APPROVED AND GET FULLY PAID, YOU WILL HAVE TO PAY ATTENTION TO THE INSTRUCTIONS AND SHOW THAT YOU COULD REMEMBER SOME OF THE WORDS THAT YOU STUDY. </FONT> You will receive feedback telling you whether you have been able to remember the words.</strong> </h1><br>

            <h1 style='color: black;text-align: left;background: white;font: caption;'> 
        <strong><FONT color='#CC5500'>If you agree to be in the study, you will do the following things.</FONT> First, the experiment will ask for you to input your ID in Prolific. You must use desktop or PC to do this experiment. You must use <FONT color='#CC5500'> Chrome</FONT> as your browser. In these trials, you will see a list of words to remember. After each list, you will see some digits to add up. Then type the sum. You will then be given the first two letters of a word you studied. If you can remember, type the word that begins with those two letters. </strong> 
        </h1> <br> 
            <h1 style='color: black;text-align: left;background: white;font: caption;'> We will protect your information and make every effort to keep your personal information confidential, but we cannot guarantee absolute confidentiality. No information which could identify you will be shared in publications about this study. Your personal information may be shared outside the research study if required by law. We also may need to share your research records with other groups for quality assurance or data analysis. These groups include the Indiana University Institutional Review Board or its designees, and state or federal agencies who may need to access the research records (as allowed by law). </h1><br>

            <h1 style='color: black;text-align: left;background: white;font: caption;'> If you have questions about the study or encounter a problem with the research, contact the researcher. For questions about the study, contact either Shuchun Lai at shulai@iu.edu , or Dr. Richard Shiffrin at shiffrin@indiana.edu.
            For questions about your rights as a research participant, to discuss problems, complaints, or concerns about a research study, or to obtain information or to offer input, please contact the IU Human Research Protection Program office at 800-696-2949 or at irb@iu.edu. </h1><br>
            
            <h1 style='color: black;text-align: left;background: white;font: caption;'> Thank you for agreeing to participate in our research. Before you begin, please note that the data you provide may be collected and used by Prolific as per its privacy agreement. Additionally, this research is for subjects over the age of 18*; if you are under the age of 18, please do not complete this survey.</h1><br>
            `,
        
        name: 'consent', 
        options:[`I have read and understand this information and agree to join this study. <p style='text-align: left'> Clicking to confirm, then press 'enter' to continue.</p>`],
        required: true
        }, 
    ],
    };
    if (is_inst_fullscreen) {
        timeline.push(enterid);
        timeline.push(browser_check);
        timeline.push(instructions);
        timeline.push(enter_fullscreen);
    }
    // timeline.push(enterid)
    // timeline.push(instructions)


    var instructions_practice = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: `
    <p style='text-align: justify;color: black;background: white;font: caption-;''>(1) <strong>A list of words will appear on the screen one at a time.</strong> Study the words as they appear.</p>
    <p style='text-align: justify;color: black;background: white;font: caption-;''>(2)<strong>After a brief blank period, you will see a series of numbers.</strong> Add those as they come, and when you see the words “TYPE THE SUM”, use the number keys to type your answer. </p>
    <p style='text-align: justify;color: black;background: white;font: caption-;''>(3) <strong>Next you will be tested to assess your memory for the words from the list you JUST studied.</strong> You will be shown the first two letters of one of the words in that list, and try to remember that word. </p>
        <p style='text-align: justify;color: black;background: white;font: caption-;''>(4)<strong>If you can recall it</strong>, type the entire word, including the first two letters, in the space provided. You will be told if you were correct. <strong>If you cannot remember</strong>, then type the word 'none'. </p>
        
    
    <p style='text-align: justify;color: black;background: white;font: caption-;''>(5)You will see several tests like this for each list, each with different first two letters. </p>
    <p style='text-align: justify;color: black;background: white;font: caption-;''>(6)There will be 10 lists of words, each followed by memory tests for the words on that list.  </p> <br>
    <p style='text-align: justify;color: black;background: white;font: caption-;''>Do not worry if you were unsure about the words during the test. That is normal, but make your best guess. </p>

    <p style='text-align: justify;color: black;background: white;font: caption-;''><strong>Please do not use pen, paper or any tool to help you remember!</strong> </p>

    <p style='text-align: justify;color: black;background: white;font: caption-;''>Before you begin, please take a moment to minimize distractions. This study will require your undivided attention to complete tasks accurately.</p>
    <p style='text-align: justify;color: black;background: white;font: caption-;''> Please start the first list now by pressing the RETURN/ENTER key. </p>

    `,
    post_trial_gap: posgap_duration,
    trial_duration: instruction_duration,//1hr if not 
    choices: choiceenter
    };


    var instructions_test = {//not used here becuase there is only one practice trial
    type: jsPsychHtmlKeyboardResponse,
    stimulus: `
    <p style='text-align: justify;color: black;background: white;font: caption-;''>
        Now you have finished the practice. When ready, start the study list with the ‘enter’ key.</p>
    `,
    post_trial_gap: posgap_duration,
    trial_duration: instruction_duration,
    choices: choiceenter
    };

    var instructions_between = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: `
    <p style='text-align: justify;color: black;background: white;font: caption-;''>
        Type the 'enter' key to see the next list of words</p>
    `,
    post_trial_gap: posgap_duration,
    trial_duration: instruction_duration_between,
    choices: choiceenter
    };


    if (condi=='f'){mes = `The first cues will be for words seen in the first list studied, list number 1. You will see first the message: “LIST NUMBER 1”. The next set of cues will be for list number 2, and you will first see the messages “LIST NUMBER 2”, and so on until the cues for list number 10 will be given. Note that sometimes the cue letters will also have a different word in the following list, and you should type both words in the spaces provided if you can recall both.`}
    else if (condi=="b"){mes=`<strong>There will be 10 sets of cues presented. You will see a list number presented before each set of cues, indicating the list in which the words were studied. </strong> <br>
    (1) The first cues will be for words seen in the last list studied, list number 10, and you will first see the message “LIST NUMBER 10”.<br> 
    (2) The next set of cues will be for the second to last list, list number 9, and you will first see the message “LIST NUMBER 9”, and so on until the cues for list number 1 will be given. <br>
    (3) Note that sometimes a cue letter will also be associted with a different word in the surronding lists, and you should type both words in the spaces provided if you can recall both.`}
    else (mes='')

    finalint_text = `<p style='text-align: justify;color: black;background: white;font: caption-;paddingRight =30px; paddingLeft =30px;'>

        <strong>You have now completed the first part of the study. </strong><br>
        The next part will test your memory for <strong>ALL</strong> the words you have seen in this study, whether they were on a studied list or not on a studied list and just tested. <br>

        You will see two letter cues, just as before, but now there will be <strong>two spaces</strong> to type words beginning with those two letters: <br><br>

        For  <strong>some</strong> cues you will have seen <strong>only one word</strong> beginning with those letters; and for <strong>some</strong> cues you will have seen <strong>two words</strong> beginning with those letters. <br>
        (1) If you  can <strong>recall no word</strong> starting with those letters, type 'none' in both spaces.<br> 
        (2) If you <strong>recall one word</strong>, type it in the first space and type 'none' in the second space.<br>
        (3) If you can <strong>recall two different words</strong>, type them in the two spaces. <br>
        (4) After both spaces are filled you will be told if any of the words you recalled were correct, <br><br>

        ${mes}<br><br>

    <strong>Try to respond as fast and as accurate as possible.</strong> <br><br>

    If you have read and understood these new instructions, press the RETURN/ENTER key to go to the testing.`

        
    

    var instructions_finaltest = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: finalint_text,
    post_trial_gap: posgap_duration,
    trial_duration: instruction_duration,
    choices: keychoice_finaltest
    // minimum_valid_rt:2000,
    // response_ends_trial:false
    };
    // timeline.push(instructions_finaltest)


    //********************************************************************************************************
    //                   Initial expeirments
    //********************************************************************************************************
    //
    // .
    //.
    // 
    //
    //********************************************************************************************************

    timeline_test_all = [];
    for (let i_trial=0; i_trial<num_listtotest; i_trial++){


    const word_arobj_itrial = tot_word_arobj_nf_rd_slice[i_trial];
    const digit_list_itrial = tot_digit_list_nf[i_trial];
    const digits_list_sum_itrial = tot_correct_sum[i_trial];
    const word_test_arobj_itrial = tot_word_test_arobj_nf[i_trial];


    const digit_list_object = range(0,num_digits_pres).map(i=>{
        return {
        digits: digit_list_itrial[i],
        prespos: i+1 //[1,20]
        }
    });

    var ISI = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: '',
        choices: "NO_KEYS",
        trial_duration: 100,
    };   

    /////////////////////////////////////////////////////
    ////////////////// study
    /////////////////////////////////////////////////////

    // var prompt_study = {
    //   type: jsPsychHtmlKeyboardResponse,
    //   stimulus: 'Now you will see the study list, remember the words as they appear',
    //   choices: "NO_KEYS",
    //   trial_duration: prompt_duration,
    //   data:{
    //     task: "prompt"
    //   },
    //   post_trial_gap: posgap_duration
    // };

    

    var v_study = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: JT('wordchosen_initial'),
        choices: "NO_KEYS",
        trial_duration: study_duration,
        post_trial_gap: posgap_duration,
        data: {
        task: "pretest_study",
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
        }
    };
        

    // console.log(word_arobj_itrial)
    var study_procedure = {
        timeline: [v_study],
        timeline_variables: word_arobj_itrial
    };

    
    /////////////////////////////////////////////////////
    ////////////////// counting
    /////////////////////////////////////////////////////

    var prompt_digits = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: 'Summing up the digits as they appear',
        choices: "NO_KEYS",
        trial_duration: prompt_duration,
        data:{
        task: "prompt"
        },
        post_trial_gap: posgap_duration
    };

    var v_digitpresent = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: JT('digits'),
        choices: "NO_KEYS",
        trial_duration: counting_duration,
        post_trial_gap: counting_gap,
        data: {
        task: "counting", 
        trialnum: i_trial+1
        // prespos: JT('prespos'),
        // stimulus_id: JT('studyimg')
        },
        on_finish: function(data){
        // console.log(digits_list_sum_itrial);
        }
    };
    var counting_present_procedure = {
        timeline: [v_digitpresent],
        timeline_variables: digit_list_object
    };
    
    var v_digitresponse = {//nondebug

        on_start: function(trial){
            if (is_showcorrect_inlog) console.log("Correct answer:",trial,trial.data.correct_response);
            if (is_debug){
            setTimeout(function () {
            jsPsych.finishTrial({
                response: {
                    question: trial.questions[0].prompt,
                    answer: 'Skipped after ' + (10 / 1000) + ' seconds'
                }
            });
            }, 10);
        }
        },
        type: jsPsychSurveyText,
        questions: [
        {prompt: `Please enter the sum using your number keyboard <p>Press 'enter' to continue.</p>`,required: true}
        ],
        on_finish: function(data){
        //   console.log(digits_list_sum_itrial);
        // console.log(current_digit_response)
        ans = Object.values(data.response)[0];
        // console.log(ans)
        data.correct = ans==data.correct_response
        // console.log(data.correct_response);
        data.responsesum = ans;
        },
        data: {
        task: "counting_response",
        correct_response: digits_list_sum_itrial,
        // is_correct: ;
        trialnum: i_trial+1,
        listnumber_1to10: i_trial+1,
        pairs_which_1or2: (i_trial+1)%2 ===0 ? 2 : 1,
        listgroup_1to5: Math.ceil((i_trial+1)/2) 
        }
    };
    


    var countingresponse_feedback_isdigit = {
        timeline: [v_digitresponse],
        loop_function: function(data){

            // console.log()

            if (is_debug) return(false)

            var cur_response = Object.values(data.values()[0].response);
            // console.log(cur_response);
            isdigits = /^[0-9]*$/.test(cur_response);
            // console.log(isdigits);
            if(!isdigits){
                warningfunc(`<div style="text-align:center ; font-size: larger; font-weight: bold; color: black;"><br> <br> <br> <br> <br> Not Digits! </div>`,warning_duration)
                return true;
            } else {

                // currentans = data.values()[0].response;
                return false;
            }
        }
    }
    // timeline.push(countingresponse_feedback_isdigit)



    var prompt_countingfeedback = {//correct and in correct
    on_start: function(){
    },
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){
        // console.log(jsPsych.data.get().last(1).values()[0])
        if(jsPsych.data.get().last(1).values()[0].correct)
        return("<p background:white>CORRECT!</p>")
        else return("<p background:white>INCORRECT!</p>")
    },
    choices: "NO_KEYS",
    trial_duration: feedbackmes_duration,
    data:{
        task: "promptfeedback"
    }, 
    post_trial_gap: posgap_duration
    };
    // timeline.push(prompt_countingfeedback)


    /////////////////////////////////////////////////////
    ////////////////// test
    /////////////////////////////////////////////////////
    var prompt_recall = {
        type: jsPsychHtmlKeyboardResponse,
        stimulus: 'Now recall the words you JUST studied',
        choices: "NO_KEYS",
        trial_duration: prompt_duration,
        data:{
        task: "prompt"
        },
        post_trial_gap: posgap_duration
    };
    

    var v_test = {
        on_start:function(trial){
        is_showcorrect_inlog?console.log(i_trial,JT('wordchosen_initial'),JT('ftl'),JT('wordchosen_finaltest')):null;
        // trial.data.starttime=Date.now();
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
            }, 10);
        }
        },
        // trial_duration: response_rtlimit_duration,
        type: jsPsychSurveyText,
        questions: function(){
        ftlnow=JT('ftl');
        return [{prompt: "".concat(`Type <strong>the whole word</strong> you just studied, starting with <strong>"`,ftlnow,`</strong>`,`________:"`,`<br> Type "none" if you don't recall`),
        required:true,
        placeholder:``.concat(`type the word starting with '`,JT('ftl'),`' or 'none'`) 
        }] 
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
        post_trial_gap: posgap_duration,
        on_finish: function(data){
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
        }
    };
    
    var test_feedback = {
    
        type: jsPsychHtmlKeyboardResponse,
        stimulus: function(){
        
        lasttrial_obj = jsPsych.data.get().last(1).values()[0];
        is_showcorrect_inlog? console.log(lasttrial_obj) : null;
        islast_correct = lasttrial_obj.correct;
        // istooslow = lasttrial_obj.is_tooslow;
        last_wordresponse = lasttrial_obj.word_response_extract;
        islast_startwithftl = last_wordresponse.slice(0,2)==lasttrial_obj.ftl;
        // console.log("feedback",lasttrial_obj.word_response,islast_startwithftl)
        // console.log("feedback2",islast_startwithftl,lasttrial_obj.is_notremembered)

        if (lasttrial_obj.rt>60000) feed_note0 = `<br><strong> <FONT color='red'>Please respond faster!!</strong> </FONT><br>`
        else feed_note0="";
        if  (!islast_startwithftl&!lasttrial_obj.is_notremembered) feed_note = "<br>Please enter the <strong>FULL</strong> words <strong>starting with the first two letter cues!</strong>";
        else feed_note="";

        if (lasttrial_obj.is_notremembered) return "." 
        feed_note = feed_note0.concat(feed_note)

        // if (istooslow) return "TOO SLOW! You need to response faster!"
        // else{
        // }
        if (islast_correct) return "Correct!".concat(feed_note);
        else return "Incorrect!".concat(feed_note);
        
        // return("ss")
        },
        data:{
        task: 'pretest_feedback'
        },
        post_trial_gap: posgap_duration,
        trial_duration: feedbackmes_wordinitial_duration,
        choices:"NO_KEYS"
    }

    // console.log(word_test_arobj_itrial)
    var test_procedure = {
        timeline: [v_test,test_feedback],
        // timeline: [v_test],
        timeline_variables: word_test_arobj_itrial
    };

    // push final test
    i_trial==0 ? timeline.push(instructions_practice) : timeline.push(instructions_between)
    timeline.push(fixation,study_procedure)
    timeline.push(prompt_digits,fixation,counting_present_procedure,countingresponse_feedback_isdigit,prompt_countingfeedback);
    timeline.push(prompt_recall,fixation,test_procedure);



    // if (i_trial==0) timeline.push(test_procedure)
    }



    /********************************************************************************************************
                    Finial tests
    /*********************************************************************************************************
    * ...
    * ...
    * ...
    * ...
    * ...
    * ...
    /**********************************************************************************************************/

    var prompt_list  = {
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){
        listnum = JT('listnumber_1to10');
        console.log(listnum)
        if (condi == "f"){
            return (`The next two letter cues are for words in list ${listnum}, an additional word with those letters will sometimes be in the surrounding lists as well.`)
        }
        else if (condi == "b"){
            return (`The next two letter cues are for words in list ${listnum}, an additional word with those letters will sometimes be in the surrounding lists list as well.`)
        }
    },
    choices: "NO_KEYS",
    trial_duration: prompt_finaltestlist_duration,
    data:{
        task: "prompt"
    },
    post_trial_gap: posgap_duration
    }

    var v_finaltest = {

    on_start: function(trial){

        if (is_showcorrect_inlog) console.log("Correct answer:",trial.data.wordchosen_finaltest,"trial:",JT('testpos_final'));
        // setTimeout(endTrialAfterDuration, trialDurationLimit*2);
        if (is_debug){
            setTimeout(function () {
            jsPsych.finishTrial({
                response: {
                    question: trial.questions[0].prompt,
                    answer: 'Skipped after ' + (10 / 1000) + ' seconds'
                }
            });
            }, 10);
        }
    },
    on_load: function(){


        //****************************************************
        //                    It makes typing 
        //****************************************************
        document.getElementById('input-0').addEventListener('keydown', function (event) {
        // Check if the Enter key is pressed
        if (event.key === 'Enter') {
            // Prevent the default Enter key behavior (e.g., form submission)
            event.preventDefault();

            // Call the function to move focus to the next input and end the trial if needed
            moveToNextInputAndEndTrial();
        }
        });

        function moveToNextInputAndEndTrial() {
        // Get the currently focused input element
        var currentInput = document.activeElement;

        // Find the next input element
        var nextInput = getNextInput(currentInput);

        // Set focus on the next input element
        if (nextInput) {
            nextInput.focus();
        } else {
            // If there is no next input, end the trial
            jsPsych.finishTrial();
        }
        }

        function getNextInput(currentInput) {
        // Find all input elements in the document
        var inputElements = document.getElementsByTagName('input');

        // Find the index of the current input element
        var currentIndex = Array.prototype.indexOf.call(inputElements, currentInput);

        // Find the next input element in the array
        var nextIndex = currentIndex + 1;
        var nextInput = inputElements[nextIndex];

        return nextInput;
        }
    },
    // trial_duration: finaltest_rtlimit_duration,
    trial_duration: 1000,
    type: jsPsychSurveyText,
    questions: function(){
        ftlnow=JT('ftl');
        return([{
        prompt: "".concat(`Type <strong>the whole word</strong> you studied in <strong>ALL</strong> previous lists, starting with <strong>"`,ftlnow,`</strong>`,`________"<br><br>If you only remember one word, please enter it in the first blank space.<br><br> Press 'enter' key to go to next blank or next cues`,"<br><br>The first word if you remember:"),
        placeholder:``.concat(`type the word starting with '`,JT('ftl'),`' or 'none'`),
        required: true
        }, 
        {
        prompt: `The second word if you remember:`,
        placeholder:``.concat(`type the word starting with '`,JT('ftl'),`' or 'none'`),
        required: true
        }])
    },
    data:{
        task: 'finalt_response',
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
        // console.log(data)
        if (data.response===null){
            word_response="";
            // data.is_tooslow = 1;
        }else{
            word_response = Object.values(data.response);
            // data.is_tooslow= 0;
        }
        // word_response = data.response==null ? [] : Object.values(data.response);
        data.word_response_original = word_response;
        data.word_response = word_response.map(iword=>iword.toLowerCase().replace(/\s/g, ''));
        data.is_repeatanswer = word_response[0]===word_response[1]
        data.word1_response = data.word_response[0];
        data.word2_response = data.word_response[1];
        data.response_numberofnone = word_response.filter(x=>x==="none").length;
        data.is_correct_repeates_condi = data.wordcondi==="repeat" && data.response_numberofnone===0;
        data.is_correct_unique_condi = data.wordcondi==="unique" && data.response_numberofnone===1;
        data.is_repeat_word1_reverse = data.word1_response === data.wordchosen_finaltest[1];
        data.is_repeat_word2_reverse = data.word2_response === data.wordchosen_finaltest[0];
        if (data.wordcondi==="unique"){
        if (data.is_repeat_word2_reverse && !data.is_repeatanswer){//second word correct and not repeat answer
            data.is_correct_first = data.word1_response==="none";
            data.is_correct_second = data.wordchosen_finaltest.includes(data.word2_response);
        }else{//if not second correctS
            data.is_correct_first = data.wordchosen_finaltest.includes(data.word1_response) && true; //convert to boollen dummy code
            data.is_correct_second = data.word2_response==="none";
        }
        } else if (data.wordcondi==="repeat"){
        data.is_correct_first = data.wordchosen_finaltest.includes(data.word1_response) && true; //convert to boollen dummy code
        data.is_correct_second = data.wordchosen_finaltest.includes(data.word2_response) && !data.is_repeatanswer;
        }

        data.is_correct_word1_precise = data.wordchosen_finaltest.includes(data.word1_response) && true;//changed
        data.is_correct_word2_precise = data.wordchosen_finaltest.includes(data.word2_response) && !data.is_repeatanswer;//changed
        data.is_correct_word12_precise = data.is_correct_word1_precise && data.is_correct_word2_precise;//changed; repeat correct when all correct
        data.is_correct_unique_precise = data.is_correct_word1_precise || data.is_correct_word2_precise; //unique correct when one of those is correct
        // console.log(data.is_correct_word1_precise,data.is_correct_word2_precise);

        //assign index to the word
        data.crword1_location = data.is_correct_word1_precise? data.wordchosen_finaltest.indexOf(data.word1_response) : null;
        data.crword2_location = data.is_correct_word2_precise? data.wordchosen_finaltest.indexOf(data.word2_response) : null;

        //assign whether the word is tested if the word is correct
        let istest_list = [data.is_test_inpair1,data.is_test_inpair2];
        data.is_crword_unique_tested = data.is_correct_unique_precise? JT('is_test') : null; 
        data.is_crword1_repeat_tested = data.is_correct_word1_precise? istest_list[data.crword1_location] : null;
        data.is_crword2_repeat_tested = data.is_correct_word2_precise? istest_list[data.crword2_location] : null;

        data.is_correct_repeat_precise = data.is_correct_first&&data.is_correct_second;

        // console.log(jsPsych.data.get().select(['word1_response','word2_response','correct']))
        firstcr = jsPsych.data.get().select('is_correct_first').values;
        secondcr = jsPsych.data.get().select('is_correct_second').values;
        initialcr = jsPsych.data.get().select('correct').values;
        // console.log([...firstcr,...secondcr,...initialcr])
        // console.log(average([...firstcr,...secondcr,...initialcr]))
        // console.log(average([1,2,3]))
        // console.log(average([true,false,false]))
        // console.log(data.word_response,data.word1_response)
    },
    post_trial_gap: posgap_duration
    };


    var finaltest_feedback = {
    on_start: function(trial){
        is_showcorrect_inlog? console.log("feedback",jsPsych.data.get().last(1).values()[0]) : null
    },
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){

        
        lasttrial_obj = jsPsych.data.get().last(1).values()[0];
        if (lasttrial_obj.rt>20000) {feed_note0 = `<br><strong> Please respond faster!!</strong> <br>`; lasttrial_obj.is_tooslow=1}
        else{ feed_note0="";  lasttrial_obj.is_tooslow=0}
        // istooslow = lasttrial_obj.is_tooslow;
        iscorrect1 = lasttrial_obj.is_correct_first ? "CORRECT! " : "INCORRECT! ";
        iscorrect2 = lasttrial_obj.is_correct_second ? "CORRECT! " : "INCORRECT! ";
        iscorrect1 = lasttrial_obj.word1_response==='none' ? '     ' : iscorrect1; 
        iscorrect2 = lasttrial_obj.word2_response==='none' ? '     ' : iscorrect2; 
        
        
        responsefeed1 = ``.concat("Word 1: ", `<strong>`,iscorrect1,`</strong>`)
        responsefeed2 = ``.concat("Word 2: ", `<strong>`,iscorrect2,`</strong>`)
        // console.log(lasttrial_obj.wordchosen_finaltest)
        // console.log(capitalizeStringinArr(lasttrial_obj.wordchosen_finaltest))
        return `<p style='text-align: left;'>`.concat(responsefeed1,`<br>`,responsefeed2,'</p>')
    },
    data:{
        task: 'finalt_feedback',
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
        // trialnum: 
    },
    trial_duration: feedbackmes_wordinitial_duration,
    choices:"NO_KEYS",
    post_trial_gap: posgap_duration
    // choices:"enter"
    }



    var finaltest_procedure = {
        timeline: [
            {
                timeline: [prompt_list], // Add the instruction trial
                // timeline_variables: tot_word_finaltest_arobj,
                conditional_function: function () {
                    // Show instruction every 10 trials
                    var currentTrial = JT('listnumber_1to10', true);
                    // console.log(JT('listnumberChange') && condi!='r')
                    if (condi!='r') return JT('listnumberChange')
                    else return false
                },
            },
            {
                timeline: [v_finaltest, finaltest_feedback],
                on_finish: function (data) {
                    data.timelasted = Date.now() - lastActivityTime;
                },
                // conditional_function: function(){ //temporary, are to be removed!
                //     return JT('listnumber_1to10') === 1 //temporary, are to be removed!
                // } //temporary, are to be removed!
            }
        ],
        timeline_variables: tot_word_finaltest_arobj,
    };

    // timeline.push(finaltest_procedure)

    var toolUsageTrial = {
    type: jsPsychHtmlButtonResponse,
    stimulus: 'Did you use any tools to help you remember? <br><br> Please provide an honest answer.<br> This answer will not affect your reward.',
    choices: ['Yes', 'No'],
    // button_html: '<div id="button-container">%choices%</div><div id="stimulus-container" style="margin-top: 20px;">%stimulus%</div>',
    on_finish: function (data) {
        // Store the participant's response
        var usedTools = data.response === 0 ? 'Yes' : 'No';
        jsPsych.data.addProperties({ usedTools: usedTools });
    }
    };

    // Define a conditional trial that appears only if the participant answered 'No'
    var penPaperTrial ={
    timeline: [
        {
        type: jsPsychSurveyText,
        questions: [
            { prompt: 'What did you use to help you remember? ', name: 'penPaperUsage' }
        ]
        }
    ],
    conditional_function: function(){
        // get the data from the previous trial,
        // and check which key was pressed
        var data = jsPsych.data.get().last(1).values()[0];
        console.log(data)
        return data.usedTools === 'Yes';
    }
    }






    var final_instruction = {
    on_start: function(trial){
        window.onbeforeunload = null;
        c1 = jsPsych.data.get().select('is_correct_word1_precise').values;
        c2 = jsPsych.data.get().select('is_correct_word2_precise').values;
        c3 = jsPsych.data.get().select('is_correct_unique_precise').values;
        c4 = jsPsych.data.get().select('correct').values;
        // nownow = jsPsych.data.get().select(['word1_response','word2_response','correct']);
        // console.log(nownow)
        // console.log([...firstcr,...secondcr,...initialcr])
        // console.log(average([...firstcr,...secondcr,...initialcr]))
        jsPsych.data.addProperties({
            all_accumulated_accuracy: parseFloat(average([...c1,...c2,...c3,...c4]).toFixed(4))
        });
    },
    type: jsPsychHtmlKeyboardResponse,
    stimulus: function(){
        c1 = jsPsych.data.get().select('is_correct_word1_precise').values;
        c2 = jsPsych.data.get().select('is_correct_word2_precise').values;
        c3 = jsPsych.data.get().select('is_correct_unique_precise').values;
        c4 = jsPsych.data.get().select('correct').values;
        nownow =  average([...c1,...c2,...c3,...c4]);
        console.log(nownow)
        // return `<p> After this page, <strong>you will be redirected to a page with the completion code, and an Excel file will be automatically downloaded</strong>. Typically, we do not need this file. However, in rare instances of server glitches, it may serve as proof of your completion. If such issues arise, we will contact you.</p><p> Please press 'enter' to continue.</p>`
        return "<p color:black>YOU FINISHED!<p><p color: black>Your overall accumulated accuracy is: <strong>".concat(
          Math.round(nownow*100)).concat(
            `%</strong><p style="color: black;">Upon completion, an automatic program will assess your overall accuracy. <strong>If the overall accuracy is too low</strong>, we will then manually evaluate your answers and behavior during the test. If we find that you fail to attend, we may request you to return the experiment or only give partial payment.</p><p> After this page, <strong>you will be redirected to a page with the completion code, and an Excel file will be automatically downloaded</strong>. Typically, we do not need this file. However, in rare instances of server glitches, it may serve as proof of your completion. If such issues arise, we will contact you.</p><p> Please press 'enter' to continue.</p>`)
    },
    // stimulus: `<p>You've finished the last task. Thanks for participating!</p>
        // <p><a href="https://app.prolific.co/submissions/complete?cc=C2P9U8QZ">Click here to return to Prolific and complete the study</a>.</p>`,
    choices: 'enter',
    data:{
        task:"instruction"
    },
    on_finish: function(data){
        jsPsych.data.get().localSave('csv', 'ekstra.csv');
        jsPsych.endExperiment();
        // jsPsych.endExperiment();
    }
    }

    function disableFullscreenListener() {
    handleFullscreenChange = false;
    }

    var exit_fullscreen = {
    on_start:function(){
        disableFullscreenListener();
    },
    type: jsPsychFullscreen,
    fullscreen_mode: false,
    delay_after: 0
    }


    timeline.push(instructions_finaltest,finaltest_procedure);
    // timeline.push(instructions_finaltest,finaltest_procedure);
    timeline.push(toolUsageTrial,penPaperTrial)
    timeline.push(exit_fullscreen,final_instruction);


    jsPsych.run(timeline);



    //********************************************************************************************************
    //                    Functions
    //********************************************************************************************************
    //
    // Brief description of this section and its purpose.
    // Additional details or important information.
    // List of key tasks or functions performed here.
    //
    //********************************************************************************************************

    function repeatedArray(x,a) {return Array.from({ length: a }, () => x)};

    function average(arr) {
        const sum = arr.reduce((acc, value) => {
            // Convert boolean to 0 or 1 for calculation
            const numericValue = typeof value === 'boolean' ? (value ? 1 : 0) : value;
            return acc + numericValue;
        }, 0);

        return sum / arr.length;
    }

    function range(start, end)
    {
        var array = new Array();
        for(var i = start; i < end; i++)
        {
            array.push(i);
        }
        return array;
    }

    function copyobj(obj_f){
        return (Object.assign({},obj_f))//this could've been done better with spread operator ...
        }

        function copyarobj(arobj_f){
        return(range(0,arobj_f.length).map(i=>copyobj(arobj_f[i])))
        }
        function randomize_ar_inside_nfar(nfar){//randomize 1*1 nonflat ar
        return range(0,nfar.length).map(i=>jsPsych.randomization.sampleWithoutReplacement(nfar[i],nfar[i].length));
    }

    function readTextFile(file) {

    const rawFile = new XMLHttpRequest();
        let content = null;
        rawFile.open("GET", file, false);
        rawFile.onreadystatechange = function () {
            if (rawFile.readyState === 4) {
                if (rawFile.status === 200 || rawFile.status === 0) {
                    content = rawFile.responseText;
                }
            }
        };
        rawFile.send(null);
        return content;
    };

    function warningfunc(message,timedur){

    var messageDiv = document.createElement("div");
        messageDiv.innerHTML = message;
        // messageDiv.className="jspsych-content-wrapper"
        messageDiv.style.padding = `350px 0`;
        messageDiv.style.textAlign = "center";
        messageDiv.style.margin = "0px"
        // messageDiv.style.height = "100vh";
        messageDiv.style.display = "flex";
        messageDiv.style.justifyContent = "center";
        var exp = document.getElementsByClassName("jspsych-content-wrapper")[0]
        exp.style.visibility = "hidden";
        jsPsych.pauseExperiment() 
        document.body.prepend(messageDiv);
        setTimeout(function() {
            document.body.removeChild(messageDiv); // Remove the div
            exp.style.visibility = "visible";
            jsPsych.resumeExperiment();
        }, timedur);//remove after 1.5s
    }

    function arrsum(ar){return(ar.reduce((a,b)=>a+b,0))};



    function startExperimentTimer() {

        const experimentTimerInterval = window.setInterval(function() {

            const currentTime = Date.now();
            if (currentTime - lastActivityTime > timeout) {
            alert(`
                Dear participant,

                We regret to inform you that the experiment has been terminated automatically due to exceeding the allowed time. Please close the page to finalize the results. And we kindly request you not to attempt this experiment again.

                We would like to thank you for your participation. Although you were unable to complete this particular experiment, we hope that you will consider joining us for future experiments. Thank you again for your time and effort; you may close the page now.
            `);
            clearInterval(experimentTimerInterval);
            console.log(currentTime - lastActivityTime);
            window.onbeforeunload = null;
            window.location = "https://www.google.com";
            window.close = true;
            jsPsych.endExperiment();
            }
        }, 1000);

        // You can add other event listeners for different types of activity (e.g., keypress, click, etc.)
    }