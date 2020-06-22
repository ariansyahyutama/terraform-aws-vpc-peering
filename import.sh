#!/bin/bash

echo "Input VPC peering id:"
read vpc_peering_id

echo "Input module name:"
read module_name

echo "Is requester? (y/n):"
read is_requester

if [ "$is_requester" == "y" ]; then
  echo $(terraform import module.${module_name}.aws_vpc_peering_connection.connection ${vpc_peering_id})
  echo $(terraform import module.${module_name}.aws_vpc_peering_connection_options.requester ${vpc_peering_id})
fi

if [ "$is_requester" == "n" ]; then
  echo $(terraform import module.${module_name}.aws_vpc_peering_connection_accepter.accepter ${vpc_peering_id})
  echo $(terraform import module.${module_name}.aws_vpc_peering_connection_options.accepter ${vpc_peering_id})
fi

SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line

terraform plan | sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" > terraform-plan.output.txt

LIST_STATE_NAME=($(cat terraform-plan.output.txt | grep "aws_route.route_table" | cut -d'+' -f2 | cut -d' ' -f2))
LIST_STATE_RTB_ID=($(cat terraform-plan.output.txt | grep "aws_route.route_table" -A 14 | grep "route_table_id" | cut -d':' -f2 | cut -d'"' -f2))
LIST_STATE_CIDR_ID=($(cat terraform-plan.output.txt | grep "aws_route.route_table" -A 14 | grep "destination_cidr_block" | cut -d':' -f2 | cut -d'"' -f2))
rm -rf cat terraform-plan.output.txt

IFS=$SAVEIFS   # Restore IFS

ITER=0
for m in "${LIST_STATE_NAME[@]}"
do

  state_name=`echo $m | sed -e 's/^[[:space:]]*//'  | sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"`
  rtb_id=`echo ${LIST_STATE_RTB_ID[$ITER]} | sed -e 's/^[[:space:]]*//' | sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"`
  cidr_block=`echo ${LIST_STATE_CIDR_ID[$ITER]} | sed -e 's/^[[:space:]]*//' | sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"`

  echo "running: terraform import ${state_name} ${rtb_id}_${cidr_block}"
  terraform import ${state_name} ${rtb_id}_${cidr_block}

  ITER=$(expr $ITER + 1)
done
