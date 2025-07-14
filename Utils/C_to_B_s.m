function Bt = C_to_B_s(Ct)
Ctrace = sum(Ct(1:3,:))/3;
Ct(1:3,:) = Ct(1:3,:)-repmat(Ctrace,3,1);
Bt = Ct;
end