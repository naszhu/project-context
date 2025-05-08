    for (let i=0; i<5;i++){

      // if_pair1 = i%2==0
      // if (i%2==0) {var j_final = 0}

      i_pairs1=i*2;
      i_pairs2=i*2+1;
      arobj_pairs1 = tot_word_arobj_nf_rd[i_pairs1];//now extract array size 20
      arobj_pairs2 = tot_word_arobj_nf_rd[i_pairs2];
      for (let j=0;j<20;j++){
        obj_pairs1 = tot_word_arobj_nf_rd[i_pairs1][j];
        obj_pairs2 = tot_word_arobj_nf_rd[i_pairs2][j];

        ftl_oppos_indexin2 = range(0,20).map(inow=>arobj_pairs2[inow].ftl).findIndex(x=>x==obj_pairs1.ftl); // for each 1, find index in array 2
        ftl_oppos_indexin1 = range(0,20).map(inow=>arobj_pairs1[inow].ftl).findIndex(x=>x==obj_pairs2.ftl); // for each 2, find in array 1

        // if (ftl_oppos_indexin2!=-1 & if_pair1){//means find item 
        if (obj_pairs1.wordcondi=="repeat"){//means find item 
          
          correspond_obj_inpair2 = arobj_pairs2[ftl_oppos_indexin2];

          if (correspond_obj_inpair2.is_test==1) obj_pairs1.istest_inpair=1; 
          else obj_pairs1.istest_inpair=0; 
          
          obj_pairs1.testpos_inpair=correspond_obj_inpair2.testpos;
          obj_pairs1.prespos_inpair=correspond_obj_inpair2.prespos;

          obj_pairs1.testpos_inpair2=correspond_obj_inpair2.testpos;
          obj_pairs1.testpos_inpair1=obj_pairs1.testpos;
          obj_pairs1.prespos_inpair2=correspond_obj_inpair2.prespos;
          obj_pairs1.prespos_inpair1=obj_pairs1.prespos;

          obj_pairs1.wordchosen_inpair1 = obj_pairs1.word_left_i;
          obj_pairs1.wordchosen_inpair2 = obj_pairs1.word_right_i;
          obj_pairs1.wordchosen_finaltest = [obj_pairs1.word_left_i,obj_pairs1.word_right_i];


          obj_pairs1.testpos_final=finalt_ind[finalt_ind_i];
          correspond_obj_inpair2.testpos_final = finalt_ind[finalt_ind_i];
          finalt_ind_i++
          // console.log(i,id1)
          id1++


        }
        // else if(ftl_oppos_indexin1!=-1 & !if_pair1){
        else if(obj_pairs2.wordcondi=="repeat"){
          
          correspond_obj_inpair1 = arobj_pairs1[ftl_oppos_indexin1];

          if (arobj_pairs1[ftl_oppos_indexin1].is_test==1) obj_pairs2.istest_inpair=1;
          else obj_pairs2.istest_inpair=0; 
          obj_pairs2.testpos_inpair=correspond_obj_inpair1.testpos;
          obj_pairs2.prespos_inpair=correspond_obj_inpair1.prespos;

          obj_pairs2.testpos_inpair1=correspond_obj_inpair1.testpos;
          obj_pairs2.testpos_inpair2=obj_pairs2.testpos;
          obj_pairs2.prespos_inpair1=correspond_obj_inpair1.prespos;
          obj_pairs2.prespos_inpair2=obj_pairs2.prespos;

          obj_pairs2.wordchosen_inpair1 = obj_pairs2.word_left_i;
          obj_pairs2.wordchosen_inpair2 = obj_pairs2.word_right_i;
          obj_pairs2.wordchosen_finaltest = [obj_pairs2.word_left_i,obj_pairs2.word_right_i];

        } else if ( (obj_pairs1.wordcondi=="unique") | (obj_pairs2.wordcondi=="unique")) {
          obj_pairs1.testpos_final=finalt_ind[finalt_ind_i];
          finalt_ind_i++
          // console.log(finalt_ind[i_pairs2],j_final)
          obj_pairs2.testpos_final=finalt_ind[finalt_ind_i];
          finalt_ind_i++
          id2=id2+2
          console.log(i,finalt_ind_i)
          obj_pairs1.wordchosen_finaltest = [obj_pairs1.wordchosen];
          obj_pairs2.wordchosen_finaltest = [obj_pairs2.wordchosen];
        } else{
          console.log("WARINING",obj_pairs1,obj_pairs2)//check if there is a condition didn't include
        }
        


      }
    }