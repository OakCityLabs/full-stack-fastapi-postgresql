.PHONY: help provision_staging provision_production deploy_staging deploy_production

help:
	@echo "  make provision_staging       Provision staging docker swarm cluster"
	@echo "  make provision_production    Provision production docker swarm cluster"
	@echo "  make deploy_staging          Deploy latest 'dev branch' code to staging servers"
	@echo "  make deploy_production       Deploy latest 'main branch' code to production servers"

provision_staging:
	ansible-playbook -i hosts.staging.yml provision.yml

provision_production:
	ansible-playbook -i hosts.production.yml provision.yml

deploy_staging:
	# Can export necessary env vars with the following command
	# export $$(cut -d= -f1 ../.source_env.staging)
	ansible-playbook -i hosts.staging.yml -vvv deploy.yml

deploy_production:
	ansible-playbook -i hosts.production.yml -vvv deploy.yml
