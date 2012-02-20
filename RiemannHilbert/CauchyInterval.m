(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage["RiemannHilbert`",{"RiemannHilbert`Common`"}];


\[Psi]p;
\[Psi]m;
\[Psi]pD;
CauchyBasisD;
LeftSingularityDataBasis;
RightSingularityDataBasis;
LeftSingularityData;
RightSingularityData;
FPCauchy;
CauchyD;
ScalarToVectorMatrix;
ScalarToMatrixMatrix;

CauchyBoundedQ::usage=
"CauchyBoundedQ[ifunlist] Determines if the Cauchy transform of ifunlist is bounded (i.e., at each joint vertex of ifunlist the functions sum to zero)";

CauchyOperator::usage=
"CauchyOperator[s,flist] returns a function C such that if glist has the same domain and number of points as flist, then C[glist] = Cauchy[s,glist]";



Begin["`Private`"];
Clear[\[Psi]p,\[Psi]m,\[Phi]];
\[Phi][n_,z_]:=(1/2) z^(2 Floor[(n+1)/2] + 1) LerchPhi[z^2,1,1/2+ Floor[(n+1)/2] ];
\[Mu][n_,z_]:=ArcTanh[z]-\[Phi][n,z];
\[Mu][n_,z_]/;z~NEqual~1:=1/2 (-PolyGamma[0,1/2]+PolyGamma[0,1/2+Floor[(1+n)/2]])//N;
\[Mu][n_,z_]/;z==-1:=-\[Mu][n,1];

\[Mu]ms[m_,z_]:=\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = 1\), \(m\)]
\*FractionBox[\(z^\((2\ j\  - 1)\)\), \(2\ j\  - 1\)]\);
\[Mu]S[n_,z_]:=\[Mu]ms[Floor[(n+1)/2],z];


\[Psi]p[0,z_]:=ArcTanh[z]//N;

SetAttributes[\[Psi]pS,Listable];
\[Psi]pS[0,z_]:=ArcTanh[z];
\[Psi]pS[n_?Positive,z_]:=z^n( ArcTanh[z]-\[Mu]S[n,1/z]);
\[Psi]pS[n_?Negative,z_]:=z^n( ArcTanh[z]-\[Mu]S[-n-1,z]);
\[Psi]pS[n_?EvenQ,z_?ZeroQ]:=0.;
\[Psi]pS[n_?OddQ,z_?ZeroQ]:=-(1/n)//N;

\[Psi]p\[Phi][n_?Positive,z_]:=z^n( ArcTanh[z]-ArcTanh[1/z]+\[Phi][n,1/z]);
\[Psi]p\[Phi][n_?Negative,z_]:=z^n( \[Phi][-n-1,z]);
\[Psi]m\[Phi][n_?Positive,z_]:=z^n( \[Psi]m[0,z]-\[Mu][n,1/z]);
\[Psi]m\[Phi][n_?Negative,z_]:=z^n( \[Psi]m[0,z]-\[Mu][-n-1,z]);


\[Psi]pH[n_?Negative,z_]:=With[{M=Floor[(-n)/2]},(z^(n+1+2 M) 1/(1-z^2) Hypergeometric2F1[1,1,3/2+M,z^2/(z^2-1)])/(1+2 M)];
\[Psi]pH[n_?Positive,z_]:=With[{M=Floor[(n+1)/2]},z^n  (ArcTanh[z]-ArcTanh[1/z])+1/(1+2 M) z^(n-1-2 M) 1/(1-z^(-2))  Hypergeometric2F1[1,1,3/2+M,z^-2/(z^(-2)-1)]];
SetAttributes[\[Psi]p,Listable];

\[Psi]p[n_?EvenQ,z_?ZeroQ]:=0.;
\[Psi]p[n_?OddQ,z_?ZeroQ]:=-(1/n)//N;

\[Psi]p[n_?Positive,z_]:=\[Psi]pS[n,z//N]//N;
\[Psi]p[n_?Negative,z_]:=\[Psi]pH[n,z//N]//N;


\[Psi]m[0,z_]:=ArcTanh[1/z];
\[Psi]m[n_,_?InfinityQ]:=0;
\[Psi]m\[Phi][n_?Negative,z_]:=With[{M=Floor[(-n)/2]},z^n (ArcTanh[1/z]-ArcTanh[z])+1/(1+2 M) z^(n+1+2 M) Hypergeometric2F1[1,1/2 +M,3/2+M,z^2]];
\[Psi]m\[Phi][n_?Positive,z_]:=With[{M=Floor[(n+1)/2]},(z^(n-1-2 M) Hypergeometric2F1[1,1/2+M,3/2+M,1/z^2])/(1+2 M)];

\[Psi]m[n_,z_]:=\[Psi]m\[Phi][n,z];


CauchyBasis[UnitInterval,k_Integer,x_]:=
-1/(I \[Pi])(\[Psi]p[k-1,IntervalToInnerCircle[x]]+\[Psi]p[-k+1,IntervalToInnerCircle[x]]);
CauchyBasis[+1,UnitInterval,k_Integer,x_]:=
-1/(I \[Pi])(\[Psi]p[k-1,IntervalToBottomCircle[x]]+\[Psi]p[-k+1,IntervalToBottomCircle[x]]);
CauchyBasis[-1,UnitInterval,k_Integer,x_]:=
-1/(I \[Pi])(\[Psi]p[k-1,IntervalToTopCircle[x]]+\[Psi]p[-k+1,IntervalToTopCircle[x]]);

CauchyBasis[f_?RightEndpointInfinityQ,k_Integer,z_]:=CauchyBasis[UnitInterval,k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,1,MapToInterval[f,z]]-1/(I \[Pi]) (\[Mu][k-1,1.]+\[Mu][k-2,1.]);

CauchyBasis[s_?SignQ,f_?RightEndpointInfinityQ,k_Integer,z_]:=CauchyBasis[s,UnitInterval,k,MapToInterval[f,z]]-CauchyBasis[s,UnitInterval,1,MapToInterval[f,z]]-1/(I \[Pi]) (\[Mu][k-1,1.]+\[Mu][k-2,1.]);

CauchyBasis[f_?LeftEndpointInfinityQ,k_Integer,z_]:=CauchyBasis[UnitInterval,k,MapToInterval[f,z]]+(-1)^(k)CauchyBasis[UnitInterval,1,MapToInterval[f,z]]+(-1)^(k)/(I \[Pi]) (\[Mu][k-1,-1.]+\[Mu][k-2,-1.]);

CauchyBasis[s_?SignQ,f_?LeftEndpointInfinityQ,k_Integer,z_]:=CauchyBasis[s,UnitInterval,k,MapToInterval[f,z]]+(-1)^(k)CauchyBasis[s,UnitInterval,1,MapToInterval[f,z]]+(-1)^(k)/(I \[Pi]) (\[Mu][k-1,-1.]+\[Mu][k-2,-1.]);

CauchyBasis[f_?IntervalDomainQ,k_Integer,z_]:=CauchyBasis[UnitInterval,k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,k,MapToInterval[f,\[Infinity]]];
CauchyBasis[s_?SignQ,f_?IntervalDomainQ,k_Integer,z_]:=CauchyBasis[s,UnitInterval,k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,k,MapToInterval[f,\[Infinity]]];


\[Mu]msD[m_,z_]:=1+\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = 2\), \(m\)]\(z^\((2\ j\  - 2)\)\)\);
\[Mu]SD[n_,z_]:=\[Mu]msD[Floor[(n+1)/2],z];


\[Psi]pD[0,z_]:=ArcTanh'[z]//N;

SetAttributes[\[Psi]pSD,Listable];
\[Psi]pSD[0,z_]:=ArcTanh[z];
\[Psi]pSD[n_?Positive,z_]:=n z^(n-1)( ArcTanh[z]-\[Mu]S[n,1/z])+z^n ( ArcTanh'[z]+1/z^2\[Mu]SD[n,1/z]);
\[Psi]pSD[n_?Negative,z_]:=n z^(n-1)( ArcTanh[z]-\[Mu]S[-n-1,z])+z^n ( ArcTanh'[z]-\[Mu]SD[-n-1,z]);


\[Psi]pD[n_?Negative,z_?InfinityQ]:=0;
\[Psi]pD[n_?(Negative[#]&&EvenQ[#]&),z_?ZeroQ]:=-(1/(n-1))//N;
\[Psi]pD[n_?(Negative[#]&&OddQ[#]&),z_?ZeroQ]:=0.;


\[Psi]pHD[n_?Negative,z_]:=With[{M=Floor[(-n)/2]},1/(1+2 M) ((2 z^(2+2 M+n) Hypergeometric2F1[1,1,3/2+M,z^2/(-1+z^2)])/(1-z^2)^2+((1+2 M+n) z^(2 M+n) Hypergeometric2F1[1,1,3/2+M,z^2/(-1+z^2)])/(1-z^2)+(z^(1+2 M+n) (-((2 z^3)/(-1+z^2)^2)+(2 z)/(-1+z^2)) Hypergeometric2F1[2,2,5/2+M,z^2/(-1+z^2)])/((3/2+M) (1-z^2)))];
\[Psi]pHD[n_?Positive,z_]:=With[{M=Floor[(n+1)/2]},z^n ((n (-ArcTanh[1/z]+ArcTanh[z]))/z-(z^(-2 M) (1+n+z^2-n z^2+2 M (-1+z^2)) Hypergeometric2F1[1,1,3/2+M,1/(1-z^2)])/((1+2 M) (-1+z^2)^2)+(4 z^(2-2 M) Hypergeometric2F1[2,2,5/2+M,1/(1-z^2)])/((3+8 M+4 M^2) (-1+z^2)^3))];
SetAttributes[\[Psi]pD,Listable];

\[Psi]pD[n_?Positive,z_]:=\[Psi]pSD[n,z//N]//N;
\[Psi]pD[n_?Negative,z_]:=\[Psi]pHD[n,z//N]//N;


CauchyBasisD[_?SignQ,_Integer,_?InfinityQ]:=0;
CauchyBasisD[f_IFun,k_,x_]:=CauchyBasisD[f//Domain,k,x];
CauchyBasisD[s_?SignQ,f_IFun,k_,x_]:=CauchyBasisD[s,f//Domain,k,x];

CauchyBasisD[UnitInterval,k_,x_]:=
-1/(I \[Pi])IntervalToInnerCircleD[x] (\[Psi]pD[k-1,IntervalToInnerCircle[x]] +\[Psi]pD[-k+1,IntervalToInnerCircle[x]]);
CauchyBasisD[+1,UnitInterval,k_,x_]:=
-1/(I \[Pi])IntervalToBottomCircle'[x](\[Psi]pD[k-1,IntervalToBottomCircle[x]]+\[Psi]pD[-k+1,IntervalToBottomCircle[x]]);
CauchyBasisD[-1,UnitInterval,k_,x_]:=
-1/(I \[Pi])IntervalToTopCircle[x](\[Psi]pD[k-1,IntervalToTopCircle[x]]+\[Psi]pD[-k+1,IntervalToTopCircle[x]]);

CauchyBasisD[f_?RightEndpointInfinityQ,k_,z_]:=MapToIntervalD[f,z](CauchyBasisD[UnitInterval,k,MapToInterval[f,z]]-CauchyBasisD[UnitInterval,1,MapToInterval[f,z]]);

CauchyBasisD[s_?SignQ,f_?RightEndpointInfinityQ,k_,z_]:=MapToIntervalD[f,z](CauchyBasisD[s,UnitInterval,k,MapToInterval[f,z]]-CauchyBasisD[s,UnitInterval,1,MapToInterval[f,z]]);

CauchyBasisD[f_?RightEndpointInfinityQ,k_Integer,z_]/;z~NEqual~MapFromInterval[f,\[Infinity]]:=.5 ChebyshevMoment[k-1]/(2 \[Pi]\[NonBreakingSpace]I)-.5 ChebyshevMoment[0]/(2 \[Pi]\[NonBreakingSpace]I);

CauchyBasisD[f_?LeftEndpointInfinityQ,k_,z_]:=MapToIntervalD[f,z](CauchyBasisD[UnitInterval,k,MapToInterval[f,z]]+(-1)^(k)CauchyBasisD[UnitInterval,1,MapToInterval[f,z]]);

CauchyBasisD[s_?SignQ,f_?LeftEndpointInfinityQ,k_,z_]:=MapToIntervalD[f,z] (CauchyBasisD[s,UnitInterval,k,MapToInterval[f,z]]+(-1)^(k)CauchyBasisD[s,UnitInterval,1,MapToInterval[f,z]]);

CauchyBasisD[f_?LeftEndpointInfinityQ,k_Integer,z_]/;z~NEqual~MapFromInterval[f,\[Infinity]]:=(-1)^k (.5 ChebyshevMoment[k-1]/(2 \[Pi]\[NonBreakingSpace]I)-.5 ChebyshevMoment[0]/(2 \[Pi]\[NonBreakingSpace]I));



LeftSingularityDataBasis[f_IFun,k_]:=LeftSingularityDataBasis[f//Domain,k];
LeftSingularityDataBasis[f_IFun,k_,t_]:=LeftSingularityDataBasis[f//Domain,k,t];
LeftSingularityDataBasis[s_?SignQ,f_IFun,k_]:=LeftSingularityDataBasis[s,f//Domain,k];
RightSingularityDataBasis[f_IFun,k_]:=RightSingularityDataBasis[f//Domain,k];
RightSingularityDataBasis[f_IFun,k_,t_]:=RightSingularityDataBasis[f//Domain,k,t];
RightSingularityDataBasis[s_?SignQ,f_IFun,k_]:=RightSingularityDataBasis[s,f//Domain,k];

LeftSingularityDataBasis[UnitInterval,k_Integer]:={(-1)^(k-1) Log[2]/(2 I \[Pi])+(-1)^(k-1)/(I \[Pi]) (\[Mu][k-1,-1]+\[Mu][k-2,-1]),-(-1)^(k-1)/(2 I \[Pi]),-1};
RightSingularityDataBasis[UnitInterval,k_Integer]:={-Log[2]/(2 I \[Pi])+1/(I \[Pi]) (\[Mu][k-1,1]+\[Mu][k-2,1]),1/(2 I \[Pi]),1};


LeftSingularityDataBasis[f_?RightEndpointInfinityQ,k_Integer]:=LeftSingularityDataBasis[UnitInterval,k]//{#[[1]]-LeftSingularityDataBasis[UnitInterval,1][[1]]-1/(I \[Pi]) (\[Mu][k-1,1]+\[Mu][k-2,1])+#[[2]] Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]],#[[2]],#[[3]]Exp[I Arg[MapToIntervalD[f,f//LeftEndpoint]]]}&;
RightSingularityDataBasis[f_?LeftEndpointInfinityQ,k_Integer]:=RightSingularityDataBasis[UnitInterval,k]//{#[[1]]-(-1)^(k-1) RightSingularityDataBasis[UnitInterval,1][[1]]-(-1)^(k-1)/(I \[Pi]) (\[Mu][k-1,-1]+\[Mu][k-2,-1])+#[[2]] Log[Abs[MapToIntervalD[f,f//RightEndpoint]]],#[[2]],#[[3]]Exp[I Arg[MapToIntervalD[f,f//RightEndpoint]]]}&;


LeftSingularityDataBasis[f_?DomainQ,k_Integer]:=LeftSingularityDataBasis[UnitInterval,k]//{#[[1]]-CauchyBasis[UnitInterval,k,MapToInterval[f,\[Infinity]]]+#[[2]] Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]],#[[2]],#[[3]]Exp[I Arg[MapToIntervalD[f,f//LeftEndpoint]]]}&;
RightSingularityDataBasis[f_?DomainQ,k_Integer]:=RightSingularityDataBasis[UnitInterval,k]//{#[[1]]-CauchyBasis[UnitInterval,k,MapToInterval[f,\[Infinity]]]+#[[2]] Log[Abs[MapToIntervalD[f,f//RightEndpoint]]],#[[2]],#[[3]]Exp[I Arg[MapToIntervalD[f,f//RightEndpoint]]]}&;

LeftSingularityDataBasis[f_?DomainQ,k_Integer,t_?ScalarQ]:=LeftSingularityDataBasis[f,k]//{#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&;
LeftSingularityDataBasis[s_?SignQ,f_,k_Integer]:=LeftSingularityDataBasis[f,k]//{#[[1]]-#[[2]] I s \[Pi],#[[2]]}&;

RightSingularityDataBasis[f_?DomainQ,k_Integer,t_?ScalarQ]:=RightSingularityDataBasis[f,k]//{#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&;
RightSingularityDataBasis[s_?SignQ,f_,k_Integer]:=RightSingularityDataBasis[f,k]//{#[[1]]+#[[2]] I s \[Pi],#[[2]]}&;

LeftSingularityData[f_IFun]:=Join[MapDot[Most[LeftSingularityDataBasis[f,#]]&,f//DCT],{LeftSingularityDataBasis[f,1]//Last}];
RightSingularityData[f_IFun]:=Join[MapDot[Most[RightSingularityDataBasis[f,#]]&,f//DCT],{RightSingularityDataBasis[f,1]//Last}];

LeftSingularityData[f_IFun,t_?ScalarQ]:=LeftSingularityData[f]//{#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&;
LeftSingularityData[s_?SignQ,f_IFun]:=LeftSingularityData[f]//{#[[1]]-#[[2]] I s \[Pi],#[[2]]}&;

RightSingularityData[f_IFun,t_?ScalarQ]:=RightSingularityData[f]//{#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&;
RightSingularityData[s_?SignQ,f_IFun]:=RightSingularityData[f]//{#[[1]]+#[[2]] I s \[Pi],#[[2]]}&;



FPCauchyBasis[+1,UnitInterval,k_Integer,g_IFun?UnitIntervalFunQ]:=IFun[Module[{j},
Join[{LeftSingularityDataBasis[+1,UnitInterval,k]//First},-2(ArcTanh[IntervalToBottomCircle[Points[g]//Rest//Most]])/(I \[Pi]) ChebyshevT[k-1, Points[g]//Rest//Most]+(((PadRight[4 Riffle[Reverse[Table[1/j,{j,1.,k-1,2}]],0]//(If[OddQ[k],Join[{0},#],#]&),Length[g]])//HalfFirst//InverseDCT)/(2 I \[Pi])//Rest//Most),
{RightSingularityDataBasis[+1,UnitInterval,k]//First}]
],g//Domain];
FPCauchyBasis[-1,UnitInterval,k_Integer,g_IFun?UnitIntervalFunQ]:=IFun[Module[{j},
Join[{LeftSingularityDataBasis[-1,UnitInterval,k]//First},-2(ArcTanh[IntervalToTopCircle[Points[g]//Rest//Most]])/(I \[Pi]) ChebyshevT[k-1, Points[g]//Rest//Most]+(((PadRight[4 Riffle[Reverse[Table[1/j,{j,1.,k-1,2}]],0]//(If[OddQ[k],Join[{0},#],#]&),Length[g]])//HalfFirst//InverseDCT)/(2 I \[Pi])//Rest//Most),
{RightSingularityDataBasis[-1,UnitInterval,k]//First}]
],g//Domain];


FPCauchyBasis[s_?SignQ,f_?RightEndpointInfinityQ,k_Integer,g_IFun]/;f~NEqual~Domain[g]:=IFun[Values[FPCauchyBasis[s,UnitInterval,k,g//ToUnitInterval]]-Values[FPCauchyBasis[s,UnitInterval,1,g//ToUnitInterval]]-1/(I \[Pi]) (\[Mu][k-1,1.]+\[Mu][k-2,1.])//#+LeftSingularityDataBasis[UnitInterval,k][[2]] Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]] BasisVector[Length[#]][1]&
,g//Domain];
FPCauchyBasis[s_?SignQ,f_?LeftEndpointInfinityQ,k_Integer,g_]/;f~NEqual~Domain[g]:=IFun[Values[FPCauchyBasis[s,UnitInterval,k,g//ToUnitInterval]]+(-1)^(k)Values[FPCauchyBasis[s,UnitInterval,1,g//ToUnitInterval]]+(-1)^(k)/(I \[Pi]) (\[Mu][k-1,-1.]+\[Mu][k-2,-1.])//#+RightSingularityDataBasis[UnitInterval,k][[2]] Log[Abs[MapToIntervalD[f,f//RightEndpoint]]] BasisVector[Length[#]][-1]&
,g//Domain];


FPCauchyBasis[s_?SignQ,f_?DomainQ,k_Integer,g_IFun]/;f~NEqual~Domain[g]:=IFun[Values[FPCauchyBasis[s,UnitInterval,k,g//ToUnitInterval]]-CauchyBasis[UnitInterval,k,MapToInterval[f,\[Infinity]]]+RightSingularityDataBasis[UnitInterval,k][[2]]Log[Abs[MapToIntervalD[f,f//RightEndpoint]]] BasisVector[Length[g]][-1]+LeftSingularityDataBasis[UnitInterval,k][[2]]Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]] BasisVector[Length[g]][1],g//Domain];




FPCauchyBasis[_?SignQ,f_?(!RightEndpointInfinityQ[#]&&!LeftEndpointInfinityQ[#]&),k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]&&RightEndpoint[f]~NEqual~RightEndpoint[g]:=IFun[Join[{LeftSingularityDataBasis[f,k,LeftContourArg[g]]//First},
CauchyBasis[f,k,g//Points//Rest//Most],
{RightSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?(!RightEndpointInfinityQ[#]&&!LeftEndpointInfinityQ[#]&),k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]&&RightEndpoint[f]~NEqual~LeftEndpoint[g]:=IFun[Join[{RightSingularityDataBasis[f,k,LeftContourArg[g]]//First},
CauchyBasis[f,k,g//Points//Rest//Most],
{LeftSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];





FPCauchyBasis[_?SignQ,f_?DomainQ,k_Integer,g_IFun?RightEndpointInfinityQ]/;RightEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[Join[{RightSingularityDataBasis[f,k,LeftContourArg[g]]//First},
CauchyBasis[f,k,g//Points//Rest//Most],
{0}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?DomainQ,k_Integer,g_IFun?LeftEndpointInfinityQ]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[Join[{0},
CauchyBasis[f,k,g//Points//Most//Rest],
{LeftSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?DomainQ,k_Integer,g_IFun?LeftEndpointInfinityQ]/;RightEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[Join[{0},
CauchyBasis[f,k,g//Points//Most//Rest],
{RightSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?DomainQ,k_Integer,g_IFun?RightEndpointInfinityQ]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[Join[
{LeftSingularityDataBasis[f,k,LeftContourArg[g]]//First},
CauchyBasis[f,k,g//Points//Rest//Most],
{0}],Domain[g]];


FPCauchyBasis[_?SignQ,f_?(!RightEndpointInfinityQ[#]&),k_Integer,g_IFun]/;RightEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[Join[{RightSingularityDataBasis[f,k,LeftContourArg[g]]//First},
CauchyBasis[f,k,g//Points//Rest]],Domain[g]];
FPCauchyBasis[_?SignQ,f_?(!LeftEndpointInfinityQ[#]&),k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[Join[
(CauchyBasis[f,k,g//Points//Most]),
{LeftSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?(!RightEndpointInfinityQ[#]&),k_Integer,g_IFun]/;RightEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[Join[
(CauchyBasis[f,k,g//Points//Most]),
{RightSingularityDataBasis[f,k,RightContourArg[g]]//First}],Domain[g]];
FPCauchyBasis[_?SignQ,f_?(!LeftEndpointInfinityQ[#]&),k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[Join[
{LeftSingularityDataBasis[f,k,LeftContourArg[g]]//First},
(CauchyBasis[f,k,g//Points//Rest])],Domain[g]];



FPCauchyBasis[_?SignQ,f_?DomainQ,k_Integer,g_?FunQ]:=ZeroAtInfinityFun[CauchyBasis[f,k,g//FinitePoints],Domain[g]];



\[Psi]pL[i_?Negative;;j_?Negative,x_]:=Module[{cur,k},
Join[{
cur=\[Psi]p[i,x]},
Table[If[EvenQ[k],
cur = cur x,
cur = cur x -1/k],{k,i+1,j}]]];

\[Psi]pL[i_?Positive;;j_?Positive,x_]:=Module[{cur,k},
Join[{
cur=\[Psi]p[i,x]},
Table[If[EvenQ[k],
cur = cur x,
cur = cur x -1/k],{k,i+1,j}]]];

\[Psi]pL[0;;j_?Positive,x_]:=Join[{\[Psi]p[0,x]},\[Psi]pL[1;;j,x]];
\[Psi]pL[i_?Negative;;0,x_]:=Join[\[Psi]pL[i;;-1,x],{\[Psi]p[0,x]}];
\[Psi]pL[i_?Negative;;j_?Positive,x_]:=Join[\[Psi]pL[i;;-1,x],{\[Psi]p[0,x]},\[Psi]pL[;;j,x]];


CauchyBasis[UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])(\[Psi]pL[i-1;;k-1,IntervalToInnerCircle[x]]+Reverse[\[Psi]pL[-k+1;;1-i,IntervalToInnerCircle[x]]]);
CauchyBasisS[+1,UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])(\[Psi]pL[i-1;;k-1,IntervalToBottomCircle[x]]+Reverse[\[Psi]pL[-k+1;;1-i,IntervalToBottomCircle[x]]]);
CauchyBasisS[-1,UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])(\[Psi]pL[i-1;;k-1,IntervalToTopCircle[x]]+Reverse[\[Psi]pL[-k+1;;1-i,IntervalToTopCircle[x]]]);


CauchyBasis[f:Curve[_IFun],1;;k_,z_List]:=MatrixMap[Total,CauchyBasis[UnitInterval,1;;k,ComplexMapToInterval[f,z]]];
CauchyBasis[s_?SignQ,f:Curve[_IFun],1;;k_,z_List]:=MatrixMap[Total,CauchyBasis[s,UnitInterval,1;;k,ComplexMapToInterval[f,z]]];

CauchyBasis[f:Curve[_IFun],1;;k_,z_]:=Total/@CauchyBasis[UnitInterval,1;;k,ComplexMapToInterval[f,z]];
CauchyBasis[s_?SignQ,f:Curve[_IFun],1;;k_,z_]:=Total/@CauchyBasis[s,UnitInterval,1;;k,ComplexMapToInterval[f,z]];

CauchyBasis[cr:Curve[cf_IFun,Stretch->L_],1;;k_,z_List]:=MatrixMap[Total,CauchyBasis[UnitInterval,1;;k,ComplexMapToInterval[cr,z]]]-((cf//Length)-1)CauchyBasis[UnitInterval,;;k,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];
CauchyBasis[s_?SignQ,cr:Curve[cf_IFun,Stretch->L_],1;;k_,z_List]:=MatrixMap[Total,CauchyBasis[s,UnitInterval,1;;k,ComplexMapToInterval[cr,z]]]-((cf//Length)-1)CauchyBasis[UnitInterval,;;k,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];

CauchyBasis[cr:Curve[cf_IFun,Stretch->L_],1;;k_,z_]:=(Total/@CauchyBasis[UnitInterval,1;;k,ComplexMapToInterval[cr,z]])-((cf//Length)-1)CauchyBasis[UnitInterval,;;k,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];
CauchyBasis[s_?SignQ,cr:Curve[cf_IFun,Stretch->L_],1;;k_,z_]:=(Total/@CauchyBasis[s,UnitInterval,1;;k,ComplexMapToInterval[cr,z]])-((cf//Length)-1)CauchyBasis[UnitInterval,;;k,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];


CauchyBasis[f_?RightEndpointInfinityQ,1;;k_,z_]:=CauchyBasis[UnitInterval,1;;k,MapToInterval[f,z]]//Function[mat,mat-Array[mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,1.]+\[Mu][#-2,1.])&,k]];
CauchyBasis[f_?LeftEndpointInfinityQ,1;;k_,z_]:=CauchyBasis[UnitInterval,1;;k,MapToInterval[f,z]]//Function[mat,mat+Array[(-1)^(#)(mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,-1.]+\[Mu][#-2,-1.]))&,k]];




CauchyBasisS[s_?SignQ,f_?RightEndpointInfinityQ,1;;k_,z_]:=CauchyBasisS[s,UnitInterval,1;;k,MapToInterval[f,z]]//Function[mat,mat-Array[mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,1.]+\[Mu][#-2,1.])&,k]];
CauchyBasisS[s_?SignQ,f_?LeftEndpointInfinityQ,1;;k_,z_]:=CauchyBasisS[s,UnitInterval,1;;k,MapToInterval[f,z]]//Function[mat,mat+Array[(-1)^(#)(mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,-1.]+\[Mu][#-2,-1.]))&,k]];


CauchyBasisS[s_?SignQ,f_?IntervalDomainQ,1;;k_,z_]:=CauchyBasisS[s,UnitInterval,1;;k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,1;;k,MapToInterval[f,\[Infinity]]];


CauchyBasis[s_?SignQ,d_?DomainQ,k_,x_?MatrixQ]:=CauchyBasis[s,d,k,#]&/@x//Transpose;

CauchyBasis[s_?SignQ,d_?DomainQ,k_,x_List]:=
RightJoin@@
(If[DomainMemberQ[d,#//First],CauchyBasisS[s,d,k,#],CauchyBasis[d,k,#]]&/@SplitBy[x,DomainMemberQ[d,#]&]);



CauchyBasis[s_?SignQ,d_?DomainQ,k_,x_]/;(DomainMemberQ[d,x]):=CauchyBasisS[s,d,k,x];
CauchyBasis[_?SignQ,d_?IntervalDomainQ,k_,x_]:=CauchyBasis[UnitInterval,k,x];

CauchyBasis[f_?IntervalDomainQ,1;;k_,z_]:=CauchyBasis[UnitInterval,;;k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,;;k,MapToInterval[f,\[Infinity]]];
CauchyBasisS[s_?SignQ,f_?IntervalDomainQ,1;;k_,z_]:=CauchyBasisS[s,UnitInterval,;;k,MapToInterval[f,z]]-CauchyBasis[UnitInterval,;;k,MapToInterval[f,\[Infinity]]];


LeftSingularityDataBasis[f:Curve[_IFun],1;;n_Integer]:=
Module[{pts,cb,lpD},
pts=Select[ComplexMapToInterval[f,f//LeftEndpoint],!(Abs[#+1]<100 $MachineTolerance)&];
lpD=MapToIntervalD[f,f//LeftEndpoint];
cb=Map[Total,CauchyBasis[UnitInterval,;;n,pts]];

({#[[1]]+#[[2]] Log[Abs[lpD]],#[[2]],#[[3]]Exp[I Arg[lpD]]}&/@LeftSingularityDataBasis[UnitInterval,;;n])+({#,0,0}&/@cb)
];

RightSingularityDataBasis[f:Curve[_IFun],1;;n_Integer]:=
Module[{pts,cb,lpD},
pts=Select[ComplexMapToInterval[f,f//RightEndpoint],!(Abs[#-1]<100 $MachineTolerance)&];
lpD=MapToIntervalD[f,f//RightEndpoint];
cb=Map[Total,CauchyBasis[UnitInterval,;;n,pts]];

({#[[1]]+#[[2]] Log[Abs[lpD]],#[[2]],#[[3]]Exp[I Arg[lpD]]}&/@RightSingularityDataBasis[UnitInterval,;;n])+({#,0,0}&/@cb)
];

LeftSingularityDataBasis[f:Curve[cf_IFun,Stretch->L_],1;;n_Integer]:=
Module[{pts,cb,lpD,cbinf},
pts=Select[ComplexMapToInterval[f,f//LeftEndpoint],!(Abs[#+1]<100 $MachineTolerance)&];
lpD=MapToIntervalD[f,f//LeftEndpoint];
cb=Map[Total,CauchyBasis[UnitInterval,;;n,pts]];
cbinf=((cf//Length)-1)CauchyBasis[UnitInterval,;;n,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];
({#[[1]]+#[[2]] Log[Abs[lpD]],#[[2]],#[[3]]Exp[I Arg[lpD]]}&/@LeftSingularityDataBasis[UnitInterval,;;n])+({#,0,0}&/@(cb-cbinf))
];

RightSingularityDataBasis[f:Curve[cf_IFun,Stretch->L_],1;;n_Integer]:=
Module[{pts,cb,lpD,cbinf},
pts=Select[ComplexMapToInterval[f,f//LeftEndpoint],!(Abs[#-1]<100 $MachineTolerance)&];
lpD=MapToIntervalD[f,f//RightEndpoint];
cb=Map[Total,CauchyBasis[UnitInterval,;;n,pts]];
cbinf=((cf//Length)-1)CauchyBasis[UnitInterval,;;n,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]];
({#[[1]]+#[[2]] Log[Abs[lpD]],#[[2]],#[[3]]Exp[I Arg[lpD]]}&/@RightSingularityDataBasis[UnitInterval,;;n])+({#,0,0}&/@(cb-cbinf))
];


LeftSingularityDataBasis[d_?IntervalDomainQ,1;;k_Integer]:=Array[LeftSingularityDataBasis[d,#]&,k];
RightSingularityDataBasis[d_?IntervalDomainQ,1;;k_Integer]:=Array[RightSingularityDataBasis[d,#]&,k];


LeftSingularityDataBasis[f_?IntervalDomainQ,1;;k_Integer,t_?ScalarQ]:={#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&/@LeftSingularityDataBasis[f,;;k];
LeftSingularityDataBasis[s_?SignQ,f_?IntervalDomainQ,1;;k_]:={#[[1]]-#[[2]] I s \[Pi],#[[2]]}&/@LeftSingularityDataBasis[f,;;k];

RightSingularityDataBasis[f_?IntervalDomainQ,1;;k_Integer,t_?ScalarQ]:={#[[1]]+#[[2]] I Arg[#[[3]] Exp[I t]],#[[2]]}&/@RightSingularityDataBasis[f,;;k];
RightSingularityDataBasis[s_?SignQ,f_,1;;k_]:={#[[1]]+#[[2]] I s \[Pi],#[[2]]}&/@RightSingularityDataBasis[f,;;k];



FPCauchyBasis[+1,UnitInterval,1;;n_Integer,g_IFun?UnitIntervalFunQ]:=Module[{mat,dctmat,j,k},
mat=ToeplitzMatrix[ZeroVector[n],
4 Riffle[Table[1/j,{j,1,n-1,2}],0]//(Join[{0},If[OddQ[n],Join[#,{0}],#]]&)];
dctmat=ColumnMap[InverseDCT[PadRight[HalfFirst[#],g//Length]]&,mat];

IFun[#,UnitInterval]&/@(Join[{Table[LeftSingularityDataBasis[+1,UnitInterval,k]//First,{k,n}]},-2/(I \[Pi])ArcTanh[IntervalToBottomCircle[g//Points//Rest//Most]] ColumnMap[(#//InverseDCT//Rest//Most)&,IdentityMatrix[{Length[g],n}]]+ColumnMap[(#//Rest//Most)&,dctmat]/(2 I \[Pi]),
{Table[RightSingularityDataBasis[+1,UnitInterval,k]//First,{k,n}]}
]//Transpose)];

FPCauchyBasis[-1,UnitInterval,1;;n_Integer,g_IFun?UnitIntervalFunQ]:=Module[{mat,dctmat,j,k},
mat=ToeplitzMatrix[ZeroVector[n],
4 Riffle[Table[1/j,{j,1,n-1,2}],0]//(Join[{0},If[OddQ[n],Join[#,{0}],#]]&)];
dctmat=ColumnMap[InverseDCT[PadRight[HalfFirst[#],g//Length]]&,mat];

IFun[#,UnitInterval]&/@(Join[{Table[LeftSingularityDataBasis[-1,UnitInterval,k]//First,{k,n}]},-2/(I \[Pi])ArcTanh[IntervalToTopCircle[g//Points//Rest//Most]] ColumnMap[(#//InverseDCT//Rest//Most)&,IdentityMatrix[{Length[g],n}]]+ColumnMap[(#//Rest//Most)&,dctmat]/(2 I \[Pi]),
{Table[RightSingularityDataBasis[-1,UnitInterval,k]//First,{k,n}]}
]//Transpose)];


FPCauchyBasis[s_?SignQ,f:Curve[_IFun],1;;k_Integer,g_IFun]/;f~NEqual~Domain[g]:=Module[{lD,rD,pts,vals,\[Psi]B},
{lD,rD}=MapToIntervalD[f,{f//LeftEndpoint,f//RightEndpoint}];
pts=Function[pt,Select[pt,(!DomainMemberQ[UnitInterval,#])&]]/@ComplexMapToInterval[f,Points[g]];


IFun[#,g//Domain]&/@((Values/@FPCauchyBasis[s,UnitInterval,;;k,g//ToUnitInterval])+MatrixMap[Total,CauchyBasis[UnitInterval,;;k,pts]] +
Array[RightSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[rD]] BasisVector[Length[g]][-1]+LeftSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[lD]] BasisVector[Length[g]][1]&,k])
];


FPCauchyBasis[s_?SignQ,f:Curve[cf_IFun,Stretch->L_],1;;k_Integer,g_IFun]/;f~NEqual~Domain[g]:=Module[{lD,rD,pts,vals,\[Psi]B},
{lD,rD}=MapToIntervalD[f,{f//LeftEndpoint,f//RightEndpoint}];
pts=Function[pt,Select[pt,(!DomainMemberQ[UnitInterval,#])&]]/@ComplexMapToInterval[f,Points[g]];


IFun[#,g//Domain]&/@((Values/@FPCauchyBasis[s,UnitInterval,;;k,g//ToUnitInterval])+MatrixMap[Total,CauchyBasis[UnitInterval,;;k,pts]] +
Array[RightSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[rD]] BasisVector[Length[g]][-1]+LeftSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[lD]] BasisVector[Length[g]][1]&,k]-((cf//Length)-1)CauchyBasis[UnitInterval,;;k,MapToInterval[Line[{-1,1},Stretch->L],\[Infinity]]])
];


(** TODO: Works because RightENdpointInfinityQ returns false for real line.  This should be made consistent **)

FPCauchyBasis[s_?SignQ,f_?RightEndpointInfinityQ,1;;k_Integer,g_IFun]/;f~NEqual~Domain[g]:=IFun[#,g//Domain]&/@((Values/@FPCauchyBasis[s,UnitInterval,1;;k,g//ToUnitInterval])//Function[mat,mat-Array[mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,1.]+\[Mu][#-2,1.])-LeftSingularityDataBasis[UnitInterval,#][[2]] Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]] BasisVector[Length[g]][1]&,k]]);

FPCauchyBasis[s_?SignQ,f_?LeftEndpointInfinityQ,1;;k_Integer,g_IFun]/;f~NEqual~Domain[g]:=IFun[#,g//Domain]&/@((Values/@FPCauchyBasis[s,UnitInterval,1;;k,g//ToUnitInterval])//Function[mat,mat+Array[(-1)^(#)(mat[[1]]+1/(I \[Pi]) (\[Mu][#-1,-1.]+\[Mu][#-2,-1.]))+RightSingularityDataBasis[UnitInterval,#][[2]] Log[Abs[MapToIntervalD[f,f//RightEndpoint]]] BasisVector[Length[g]][-1]&,k]]);


FPCauchyBasis[s_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun]/;f~NEqual~Domain[g]:=IFun[#,g//Domain]&/@((Values/@FPCauchyBasis[s,UnitInterval,;;k,g//ToUnitInterval])-CauchyBasis[UnitInterval,;;k,MapToInterval[f,\[Infinity]]]+
Array[RightSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[MapToIntervalD[f,f//RightEndpoint]]] BasisVector[Length[g]][-1]+LeftSingularityDataBasis[UnitInterval,#][[2]]Log[Abs[MapToIntervalD[f,f//LeftEndpoint]]] BasisVector[Length[g]][1]&,k]);



FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!RightEndpointInfinityQ[#]&&!LeftEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]&&RightEndpoint[f]~NEqual~RightEndpoint[g]:=IFun[#,g//Domain]&/@Transpose[Join[
{First/@LeftSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Most//Rest]],
{First/@RightSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];

FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!RightEndpointInfinityQ[#]&&!LeftEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]&&RightEndpoint[f]~NEqual~LeftEndpoint[g]:=IFun[#,g//Domain]&/@Transpose[Join[
{First/@RightSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Most//Rest]],
{First/@LeftSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];



FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?RightEndpointInfinityQ]/;RightEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[{First/@RightSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest//Most]],
{ZeroVector[k]}]];

FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?LeftEndpointInfinityQ]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
{ZeroVector[k]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest//Most]],
{First/@LeftSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];

FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?LeftEndpointInfinityQ]/;RightEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
{ZeroVector[k]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest//Most]],
{First/@RightSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];
FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?RightEndpointInfinityQ]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[{First/@LeftSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest//Most]],
{ZeroVector[k]}]];




FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!RightEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;RightEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
Transpose[CauchyBasis[f,;;k,g//Points//Most]],
{First/@RightSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];

FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!RightEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;RightEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
{First/@RightSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest]]
]];
FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!LeftEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~RightEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
Transpose[CauchyBasis[f,;;k,g//Points//Most]],
{First/@LeftSingularityDataBasis[f,;;k,RightContourArg[g]]}
]];
FPCauchyBasis[_?SignQ,f_?(IntervalDomainQ[#]&&!LeftEndpointInfinityQ[#]&),1;;k_Integer,g_IFun]/;LeftEndpoint[f]~NEqual~LeftEndpoint[g]:=
IFun[#,g//Domain]&/@Transpose[Join[
{First/@LeftSingularityDataBasis[f,;;k,LeftContourArg[g]]},
Transpose[CauchyBasis[f,;;k,g//Points//Rest]]
]];



FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?LeftEndpointInfinityQ]:=ZeroAtInfinityIFun[#,Domain[g]]&/@CauchyBasis[f,1;;k,g//Points//Rest];
FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_IFun?RightEndpointInfinityQ]:=ZeroAtInfinityIFun[#,Domain[g]]&/@CauchyBasis[f,1;;k,g//Points//Most];
FPCauchyBasis[_?SignQ,f_?IntervalDomainQ,1;;k_Integer,g_?FunQ]:=Fun[#,Domain[g]]&/@CauchyBasis[f,;;k,g//Points];


\[Psi]pLD[0;;m_?Positive,x_]:=Module[{cur,ph},
ph=\[Psi]pL[0;;m,x];
Join[{cur=\[Psi]pD[0,x]},
Table[cur=cur x+ph[[i]],{i,m}]
]];
\[Psi]pLD[l_?Negative;;m_?Negative,x_]:=Module[{cur,ph},
ph=\[Psi]pL[l;;m,x];
Join[{cur=\[Psi]pD[l,x]},
Table[cur=cur x+ph[[i-l]],{i,l+1,m}]
]];
\[Psi]pLD[i_?Negative;;0,x_]:=Join[\[Psi]pLD[i;;-1,x],{\[Psi]pD[0,x]}];
\[Psi]pLD[i_?Negative;;j_?Positive,x_]:=Join[\[Psi]pLD[i;;-1,x],\[Psi]pLD[0;;j,x]];

CauchyBasisD[UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])IntervalToInnerCircleD[x](\[Psi]pLD[i-1;;k-1,IntervalToInnerCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToInnerCircle[x]]]);
CauchyBasisD[+1,UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])IntervalToBottomCircle'[x](\[Psi]pLD[i-1;;k-1,IntervalToBottomCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToBottomCircle[x]]]);
CauchyBasisD[-1,UnitInterval,i_;;k_,x_]:=
-1/(I \[Pi])IntervalToTopCircle'[x](\[Psi]pLD[i-1;;k-1,IntervalToTopCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToTopCircle[x]]]);

CauchyBasisD[UnitInterval,i_;;k_,x_List]:=
-1/(I \[Pi])IntervalToInnerCircleD[x] #&/@(\[Psi]pLD[i-1;;k-1,IntervalToInnerCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToInnerCircle[x]]]);
CauchyBasisD[+1,UnitInterval,i_;;k_,x_List]:=
-1/(I \[Pi])IntervalToBottomCircle'[x]#&/@(\[Psi]pLD[i-1;;k-1,IntervalToBottomCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToBottomCircle[x]]]);
CauchyBasisD[-1,UnitInterval,i_;;k_,x_List]:=
-1/(I \[Pi])IntervalToTopCircle'[x]#&/@(\[Psi]pLD[i-1;;k-1,IntervalToTopCircle[x]]+Reverse[\[Psi]pLD[-k+1;;1-i,IntervalToTopCircle[x]]]);

CauchyBasisD[f_?RightEndpointInfinityQ,1;;k_,z_]/;MapFromInterval[f,\[Infinity]]~NEqual~z:=Array[CauchyBasisD[f,#,z]&,k];

CauchyBasisD[f_?RightEndpointInfinityQ,1;;k_,z_]:=MapToIntervalD[f,z]CauchyBasisD[UnitInterval,1;;k,MapToInterval[f,z]];
CauchyBasisD[f_?LeftEndpointInfinityQ,1;;k_,z_]:=MapToIntervalD[f,z]CauchyBasisD[UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[f_?IntervalDomainQ,1;;k_,z_]:=MapToIntervalD[f,z] CauchyBasisD[UnitInterval,1;;k,MapToInterval[f,z]];

CauchyBasisD[s_?SignQ,f_?IntervalDomainQ,1;;k_,z_]:=MapToIntervalD[f,z] CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[s_?SignQ,f_?RightEndpointInfinityQ,1;;k_,z_]:=MapToIntervalD[f,z]CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];
CauchyBasisD[s_?SignQ,f_?LeftEndpointInfinityQ,1;;k_,z_]:=MapToIntervalD[f,z]CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[f_?RightEndpointInfinityQ,1;;k_,z_List]:=
CauchyBasisD[f,1;;k,#]&/@z//Transpose;
CauchyBasisD[f_?LeftEndpointInfinityQ,1;;k_,z_List]:=
MapToIntervalD[f,z]#&/@CauchyBasisD[UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[f_?IntervalDomainQ,1;;k_,z_List]:=MapToIntervalD[f,z] #&/@CauchyBasisD[UnitInterval,1;;k,MapToInterval[f,z]];
CauchyBasisD[s_?SignQ,f_?IntervalDomainQ,1;;k_,z_List]:=MapToIntervalD[f,z] #&/@CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[s_?SignQ,f_?RightEndpointInfinityQ,1;;k_,z_List]:=MapToIntervalD[f,z]#&/@CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];
CauchyBasisD[s_?SignQ,f_?LeftEndpointInfinityQ,1;;k_,z_List]:=MapToIntervalD[f,z]#&/@CauchyBasisD[s,UnitInterval,1;;k,MapToInterval[f,z]];


CauchyBasisD[f_?DomainQ,k_,z_]:=MapToIntervalD[f,z] CauchyBasisD[UnitInterval,k,MapToInterval[f,z]];
CauchyBasisD[s_?SignQ,f_?DomainQ,k_,z_]:=MapToIntervalD[f,z] CauchyBasisD[s,UnitInterval,k,MapToInterval[f,z]];




Cauchy[f_IFun,_?InfinityQ]:=0 First[f];
Cauchy[f_List,_?InfinityQ]:=0 First[First[f]];Cauchy[f_IFun,x_]/;(LeftEndpoint[f]~NEqual~x&&Norm[First[f]]~NEqual~0.):=f//LeftSingularityData//First;
Cauchy[_?SignQ,f_IFun,x_]/;(LeftEndpoint[f]~NEqual~x&&Norm[First[f]]~NEqual~0.):=f//LeftSingularityData//First;

Cauchy[f_IFun,x_]/;(LeftEndpoint[f]~NEqual~x):=\[Infinity];
Cauchy[_?SignQ,f_IFun,x_]/;(LeftEndpoint[f]~NEqual~x):=\[Infinity];


Cauchy[f_IFun,x_]/;(RightEndpoint[f]~NEqual~x&&Norm[Last[f]]~NEqual~0.):=f//RightSingularityData//First;
Cauchy[_?SignQ,f_IFun,x_]/;(RightEndpoint[f]~NEqual~x&&Norm[First[f]]~NEqual~0.):=f//RightSingularityData//First;

Cauchy[f_IFun,x_]/;(RightEndpoint[f]~NEqual~x):=\[Infinity];
Cauchy[_?SignQ,f_IFun,x_]/;(RightEndpoint[f]~NEqual~x):=\[Infinity];

Cauchy[f_IFun,x_]:=CauchyBasis[f,;;Length[f],x].(f//DCT);
Cauchy[s_?SignQ,f_IFun,x_]:=CauchyBasis[s,f,;;Length[f],x].(f//DCT);

CauchyS[s_?SignQ,f_IFun,x_]:=CauchyBasisS[s,f,;;Length[f],x].(f//DCT);


Cauchy[f_IFun,xv_List]:=Plus@@(Map[Function[x,x #[[2]]],#[[1]]]&/@Thread[{CauchyBasis[f,;;Length[f],xv],DCT[f]}]);
Cauchy[s_?SignQ,f_IFun,xv_List]:=Plus@@(Map[Function[x,x #[[2]]],#[[1]]]&/@Thread[{CauchyBasis[s,f,;;Length[f],xv],DCT[f]}]);



Cauchy[f_List,x_]:=Plus@@(Cauchy[#,x]&/@f);
CauchyD[f_List,x_]:=Plus@@(CauchyD[#,x]&/@f);
CauchyD[k_][f_List,x_]:=Plus@@(CauchyD[k][#,x]&/@f);


Cauchy[s_?SignQ,f_List,x_]:=
Plus@@(If[DomainMemberQ[#,x],Cauchy[s,#,x],Cauchy[#,x]]&/@f);
Cauchy[s_?SignQ,f_List,x_List]:=
Plus@@(Function[U,
Flatten[
If[DomainMemberQ[U,#//First],Cauchy[s,U,#],Cauchy[U,#]]&/@SplitBy[x,DomainMemberQ[U,#]&]
,1]
]/@f);


Hilbert[lf_,z_]:=I (Cauchy[+1,lf,z]+Cauchy[-1,lf,z]);
Hilbert[lf_]:=I (Cauchy[+1,lf]+Cauchy[-1,lf]);

FPCauchy[s_?SignQ,f_IFun,g_IFun]:=IFun[Transpose[(Values/@FPCauchyBasis[s,f,;;Length[f],g])].DCT[f],g//Domain];
FPCauchy[s_?SignQ,f_List,g_?FunQ]:=FastPlus@@(FPCauchy[s,#,g]&/@f);
FPCauchy[s_?SignQ,f_List,g:{__?FunQ}]:=FPCauchy[s,f,#]&/@g;
FPCauchy[s_?SignQ,f_]:=FPCauchy[s,f,f];


CauchyBoundedQ[l_List]:=((Function[x,
Plus@@(Which[
LeftEndpoint[#]~NEqual~x,
First[#],
RightEndpoint[#]~NEqual~x,
-Last[#],
True,
0 First[#]]&/@l)]/@Select[Union@@({LeftEndpoint[#],RightEndpoint[#]}&/@l),!InfinityQ[#]&])//Abs//Max)/10//NZeroQ;


Cauchy[s_?SignQ,f_List?CauchyBoundedQ,g:{__IFun}]:=FPCauchy[s,f,g];

CauchyOperator[s_?SignQ,f_List]:=Module[{mat},
mat=CauchyMatrix[s,f];
FromValueList[#,mat.ToValueList[#]]&
];



CauchyD[f_IFun,_?InfinityQ]:=0 First[f];



CauchyD[f_IFun,xv_List]:=Plus@@(Map[Function[x,x #[[2]]],#[[1]]]&/@Thread[{CauchyBasisD[f,;;Length[f],xv],DCT[f]}]);
CauchyD[s_?SignQ,f_IFun,xv_List]:=Plus@@(Map[Function[x,x #[[2]]],#[[1]]]&/@Thread[{CauchyBasisD[s,f,;;Length[f],xv],DCT[f]}]);


CauchyD[f_List,_?InfinityQ]:=0 First[First[f]];

CauchyD[f_IFun,x_]:=CauchyBasisD[f,;;Length[f],x].(f//DCT);
CauchyD[s_?SignQ,f_IFun,x_]:=CauchyBasisD[s,f,;;Length[f],x].(f//DCT);



CauchyD[f_List,x_]:=Plus@@(CauchyD[#,x]&/@f);


CauchyD[s_?SignQ,f_List,x_]:=
Plus@@(If[DomainMemberQ[#,x],CauchyD[s,#,x],CauchyD[#,x]]&/@f);


CauchyD[s_?SignQ,f_List,x_List]:=
Plus@@(Function[U,
Flatten[
If[DomainMemberQ[U,#//First],CauchyD[s,U,#],CauchyD[U,#]]&/@SplitBy[x,DomainMemberQ[U,#]&]
,1]
]/@f);


CauchyMatrix[s_?SignQ,f_IFun?ScalarFunQ,g_?FunQ]:=Transpose[(FiniteValues/@FPCauchyBasis[s,f,;;Length[f],g])].FiniteTransformMatrix[f];


End[];
EndPackage[];
