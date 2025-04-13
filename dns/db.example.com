$TTL    604800
@       IN      SOA     ns.example.com. admin.example.com. (
                         2023102901 ; Serial
                         604800      ; Refresh
                         86400       ; Retry
                         2419200     ; Expire
                         604800 )    ; Negative Cache TTL

; Nameservers
@       IN      NS      ns.example.com.
ns      IN      A       10.211.55.14

; A Records
@       IN      A       10.211.55.14
www     IN      A       10.211.55.14
