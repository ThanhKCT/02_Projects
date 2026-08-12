function [ObjectiveFunction,truePF,nVar,nobj,VarMin,VarMax,ref_point]= problem_2obj(probnum)
switch probnum
        case 1
            ObjectiveFunction=@ZDT1;
            load ZDT1_truePF
            truePF=ZDT1_truePF;
            nVar =30;
            nobj=2;
            VarMin=zeros(1,30);VarMax=ones(1,30);
            ref_point=[7,7];
            
        case 2
            ObjectiveFunction=@ZDT2;
            load ZDT2_truePF
            truePF=ZDT2_truePF;
            nVar =30;
            nobj=2;
            VarMin=zeros(1,30);VarMax=ones(1,30);
            ref_point=[7,7];
            
        case 3
            ObjectiveFunction=@ZDT3;
            load ZDT3_truePF
            truePF=ZDT3_truePF;
            nVar =30;
            nobj=2;
            VarMin=zeros(1,30);VarMax=ones(1,30);
            ref_point=[7,7];
            
        case 4
            ObjectiveFunction=@ZDT4;
            load ZDT4_truePF
            truePF=ZDT4_truePF;
            nVar =10;
            nobj=2;
            VarMin=[0,-5,-5,-5,-5,-5,-5,-5,-5,-5];
            VarMax=[1,5,5,5,5,5,5,5,5,5];
            ref_point=[210,210];
            
        case 5
            ObjectiveFunction=@ZDT6;
            load ZDT6_truePF
            truePF=ZDT6_truePF;
            nVar =30;
            nobj=2;
            VarMin=zeros(1,nVar);VarMax=ones(1,nVar);
            ref_point=[1.5,1.5];
            
        case 6
            ObjectiveFunction=@MMF1;
            load MMF1_truePF
            truePF=MMF1_truePF;
            nVar =2;
            nobj=2;
            VarMin=[1,-1];VarMax=[3,1];
            ref_point=[9,9];
            
        case 7
            ObjectiveFunction=@MMF2;
            load MMF2_truePF
            truePF=MMF2_truePF;
            nVar =2;
            nobj=2;
            VarMin=[0,0];VarMax=[1,2];
            ref_point=[15,15];
            
        case 8
            ObjectiveFunction=@MMF4;
            load MMF4_truePF
            truePF=MMF4_truePF;
            nVar =2;
            nobj=2;
            VarMin=[-1,0];VarMax=[1,2];
            ref_point=[3,3];
            
        case 9
            ObjectiveFunction=@MMF5;
            load MMF5_truePF
            truePF=MMF5_truePF;
            nVar =2;
            nobj=2;
            VarMin=[1,-1];VarMax=[3,3];
            ref_point=[8,8];
            
        case 10
            ObjectiveFunction=@MMF7;
            load MMF7_truePF
            truePF=MMF7_truePF;
            nVar =2;
            nobj=2;
            VarMin=[1,-1];VarMax=[3,1];
            ref_point=[2,2];
            
        case 11
            ObjectiveFunction=@MMF8;
            load MMF8_truePF
            truePF=MMF8_truePF;
            nVar =2;
            nobj=2;
            VarMin=[-pi,0];VarMax=[pi,9];
            ref_point=[30,30];
           
        case 12
            ObjectiveFunction=@MMF10;
            load MMF10_truePF
            truePF=MMF10_truePF;
            nVar =2;
            nobj=2;
            VarMin=[0.1,0.1];VarMax=[1.1,1.1];
            ref_point=[18,18];
           
        case 13
            ObjectiveFunction=@MMF11;
            load MMF11_truePF
            truePF=MMF11_truePF;
            nVar =2;
            nobj=2;
            VarMin=[0.1,0.1];VarMax=[1.1,1.1];
            ref_point=[21,21];
          
        case 14
            ObjectiveFunction=@MMF12;
            load MMF12_truePF
            truePF=MMF12_truePF;
            nVar =2;
            nobj=2;
            VarMin=[0,0];VarMax=[1,1];
            ref_point=[2.5,2.5];
            
        case 15
            ObjectiveFunction=@MMF13;
            load MMF13_truePF
            truePF=MMF13_truePF;
            nVar =3;
            nobj=2;
            VarMin=[0.1,0.1,0.1];VarMax=[1.1,1.1,1.1];
            ref_point=[16,16];
           
        case 16
            ObjectiveFunction=@UF1;
            load UF1_truePF
            truePF=UF1_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[4,4];
            
        case 17
            ObjectiveFunction=@UF2;
            load UF2_truePF
            truePF=UF2_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[2,3];
            
        case 18
            ObjectiveFunction=@UF3;
            load UF3_truePF
            truePF=UF3_truePF;
            nVar =30;
            nobj=2;
            VarMin=zeros(1,30);
            VarMax=ones(1,30);
            ref_point=[5,5];
            
        case 19
            ObjectiveFunction=@UF4;
            load UF4_truePF
            truePF=UF4_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2];
            VarMax=[1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2];
            ref_point=[1.5,1.5];
            
        case 20
            ObjectiveFunction=@UF5;
            load UF5_truePF
            truePF=UF5_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[9,9];
           
        case 21
            ObjectiveFunction=@UF6;
            load UF6_truePF
            truePF=UF6_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[15,15];
           
        case 22
            ObjectiveFunction=@UF7;
            load UF7_truePF
            truePF=UF7_truePF;
            nVar =30;
            nobj=2;
            VarMin=[0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
            VarMax=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
            ref_point=[4,4];
     
            
end
end