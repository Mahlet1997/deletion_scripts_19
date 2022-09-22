use MSDB
select [job] =j.name,[description]=j.description,[step] =s.step_name,s.command from dbo.sysjobsteps s
INNER JOIN dbo.sysjobs j
on s.job_id = j.job_id
and s.subsystem ='SSIS'
