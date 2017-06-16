exec sp_MSforeachdb 'sp_removedbreplication "?" ,"both"'

exec sp_dropdistributor @no_checks= 1,@ignore_distributor=1

exec sp_dropdistpublisher  @publisher= 'ozdb',@no_checks= 1,@ignore_distributor=1

exec sp_dropdistributiondb 'distributor'

exec sp_MSforeachdb 'sp_removedbreplication "?"'

exec sp_MSforeachdb 'select "?" , *, object_name(id) from ?..syscomments where text like "%Sreplication_subscriptions%"'
use dbawork
drop view  MSreplication_subscriptions 
use ozdb_leonardo3
drop proc sp_dba_pre_carga

exec sp_addpullsubscription  @publisher=  'ozdb03'
     ,  @publisher_db=  'ozdb_rep' 
        ,  @publication=  'ozdb'
     ,  @independent_agent=  'true' 
     ,  @subscription_type=  'anonymous' 
     ,  @description=  'description' 
     ,  @update_mode=  'read only' 
     ,  @immediate_sync =  1
     
     
     
 exec    sp_droppullsubscription  @publisher=  'all'
        ,  @publisher_db=  'ozdb_rep'
        , @publication=  'ozdb'
        
        
sp_dropsubscription 'ozdb_rep', @subscriber = 'all'
        
        