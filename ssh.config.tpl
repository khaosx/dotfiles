## --------------------- Specific Host Definitions --------------------- ##
##   --------------------- Managed by 1Password ---------------------    ##
##
## The following block is injected from a 1Password Secure Note. It  
## contains specific host definitions for the internal network.

"{{ op://khaosx-infrastructure/pfkutx4v5qzxgmoehc3wjn2ugy/SSH_Specific Hosts_Config }}"

## --------------------- Global Defaults --------------------- ##
##
## These settings apply to ALL hosts unless overridden by any 
## block above.

Host *
    ForwardAgent        no
    ForwardX11          no
    Protocol            2
    ControlMaster       auto                          
    ConnectTimeout      10                           
    ServerAliveInterval 60                      
    ServerAliveCountMax 30                      

    # --- Default Credentials ---
    User "{{ op://khaosx-infrastructure/Admin User/username }}"                                 
    IdentityFile ~/.ssh/id_ed25519_jarvis
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"