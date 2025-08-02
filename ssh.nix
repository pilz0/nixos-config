{ ... }:
{
  services.openssh.banner = "
  ++  ++  ++  ++ * * * *
    ++  ++  ++  ++  ++
  .     .       .     .       .     .  . .
   .     .     .     .     .     .    .    			
     .     .       .     .       .  . / _/\ 
	..	.	.  .   .         ++++++++     ( o.o )
 .	.	.	.	.             *              > ^ <
  .     .       .     .       .     .  wooof
   .     .     .     .     .     .  . 
     .     .       .     .       .  .  o_*_o								  	
      ";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}
