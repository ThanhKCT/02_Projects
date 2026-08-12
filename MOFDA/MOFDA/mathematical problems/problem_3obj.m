function [ObjectiveFunction,truePF,nVar,nobj,VarMin,VarMax,ref_point]= problem_3obj(probnum)
switch probnum
        case 1
            ObjectiveFunction=@DTLZ1;
            load DTLZ1_truePF_forDraw
            truePF=DTLZ1_truePF_forDraw;
            nVar =7;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1];
            ref_point=[];
        case 2
            ObjectiveFunction=@DTLZ2;
            load DTLZ2_truePF_forDraw
            truePF=DTLZ2_truePF_forDraw;
            nVar =12;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[];
        case 3
            ObjectiveFunction=@DTLZ3;
            load DTLZ3_truePF_forDraw
            truePF=DTLZ3_truePF_forDraw;
            nVar =12;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[];
        case 4
            ObjectiveFunction=@DTLZ4;
            load DTLZ4_truePF_forDraw
            truePF=DTLZ4_truePF_forDraw;
            nVar =12;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[];
        case 5
            ObjectiveFunction=@DTLZ5;
            load DTLZ5_truePF
            truePF=DTLZ5_truePF;
            nVar =12;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[];
        case 6
            ObjectiveFunction=@DTLZ6;
            load DTLZ6_truePF
            truePF=DTLZ6_truePF;
            nVar =12;
            nobj=3;
            VarMin=[0,0,0,0,0,0,0,0,0,0,0,0];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[];
        case 7
            ObjectiveFunction=@MMF14;
            load MMF14_truePF
            truePF=MMF14_truePF;
            nVar =3;
            nobj=3;
            VarMin=[0,0,0];VarMax=[1,1,1];
            ref_point=[];
        case 8
            ObjectiveFunction=@MMF15;
            load MMF15_truePF
            truePF=MMF15_truePF;
            nVar =3;
            nobj=3;
            VarMin=[0,0,0];VarMax=[1,1,1];
            ref_point=[];
end      
            
end