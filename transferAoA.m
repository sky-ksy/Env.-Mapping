function blindAoA=transferAoA(AoA,TxId,Tx2Rx)  %AoA(TxId)ΪTx��Rx��AoA
% if(Tx2Rx>pi)
%     Tx2Rx=Tx2Rx-2*pi;
% elseif(Tx2Rx<=-pi)
%     Tx2Rx=Tx2Rx+2*pi;
% end
dif=Tx2Rx-AoA(TxId);
blindAoA=AoA+dif;