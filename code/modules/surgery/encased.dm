//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased
	priority = 1
	can_infect = 1
	blood_level = 1
	var/open_case_step

/datum/surgery_step/open_encased/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected, checks_only)
	if(affected.encased && affected.surgery_open_stage == open_case_step)
		return SURGERY_CAN_USE
	return SURGERY_CANNOT_USE


/datum/surgery_step/open_encased/saw
	allowed_tools = list(
		/obj/item/tool/surgery/circular_saw = 100,
		/obj/item/tool/hatchet = 75,
	)

	min_duration = SAW_OPEN_ENCASED_MIN_DURATION
	max_duration = SAW_OPEN_ENCASED_MAX_DURATION
	open_case_step = 2

/datum/surgery_step/open_encased/saw/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] begins to cut through [target]'s [affected.encased] with \the [tool]."), \
	span_notice("You begin to cut through [target]'s [affected.encased] with \the [tool]."))
	target.balloon_alert_to_viewers("Sawing...")
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/saw/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] has cut [target]'s [affected.encased] open with \the [tool]."),		\
	span_notice("You have cut [target]'s [affected.encased] open with \the [tool]."))
	target.balloon_alert_to_viewers("Success")
	affected.surgery_open_stage = 2.5

/datum/surgery_step/open_encased/saw/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_warning("[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!") , \
	span_warning("Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!") )
	target.balloon_alert_to_viewers("Slipped!")

	affected.createwound(CUT, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/retract
	allowed_tools = list(
		/obj/item/tool/surgery/retractor = 100,
		/obj/item/tool/crowbar = 75,
	)

	min_duration = RETRACT_OPEN_ENCASED_MIN_DURATION
	max_duration = RETRACT_OPEN_ENCASED_MAX_DURATION
	open_case_step = 2.5

/datum/surgery_step/open_encased/retract/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] starts to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."), \
	span_notice("You start to force open the [affected.encased] in [target]'s [affected.display_name] with \the [tool]."))
	target.balloon_alert_to_viewers("Bending...")
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/retract/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] forces open [target]'s [affected.encased] with \the [tool]."), \
	span_notice("You force open [target]'s [affected.encased] with \the [tool]."))
	target.balloon_alert_to_viewers("Success")
	affected.surgery_open_stage = 3

	//Whoops!
	if(prob(10))
		affected.fracture()

/datum/surgery_step/open_encased/retract/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_warning("[user]'s hand slips, cracking [target]'s [affected.encased]!"), \
	span_warning("Your hand slips, cracking [target]'s  [affected.encased]!"))
	target.balloon_alert_to_viewers("Slipped!")

	affected.createwound(BRUISE, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/close
	allowed_tools = list(
		/obj/item/tool/surgery/retractor = 100,
		/obj/item/tool/crowbar = 75,
	)

	min_duration = RETRACT_CLOSE_ENCASED_MIN_DURATION
	max_duration = RETRACT_CLOSE_ENCASED_MAX_DURATION
	open_case_step = 3

/datum/surgery_step/open_encased/close/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] starts bending [target]'s [affected.encased] back into place with \the [tool]."), \
	span_notice("You start bending [target]'s [affected.encased] back into place with \the [tool]."))
	target.balloon_alert_to_viewers("Bending...")
	target.custom_pain("Something hurts horribly in your [affected.display_name]!", 1)
	..()

/datum/surgery_step/open_encased/close/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] bends [target]'s [affected.encased] back into place with \the [tool]."), \
	span_notice("You bend [target]'s [affected.encased] back into place with \the [tool]."))
	target.balloon_alert_to_viewers("Success")
	affected.surgery_open_stage = 2.5

/datum/surgery_step/open_encased/close/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_warning("[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!"), \
	span_warning("Your hand slips, bending [target]'s [affected.encased] the wrong way!"))
	target.balloon_alert_to_viewers("Slipped!")
	affected.createwound(BRUISE, 20)
	affected.fracture()
	affected.update_wounds()


/datum/surgery_step/open_encased/mend
	allowed_tools = list(
		/obj/item/tool/surgery/bonegel = 100,
		/obj/item/tool/screwdriver = 75,
	)

	min_duration = BONEGEL_CLOSE_ENCASED_MIN_DURATION
	max_duration = BONEGEL_CLOSE_ENCASED_MAX_DURATION
	open_case_step = 2.5

/datum/surgery_step/open_encased/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] starts applying \the [tool] to [target]'s [affected.encased]."), \
	span_notice("You start applying \the [tool] to [target]'s [affected.encased]."))
	target.custom_pain("Something hurts horribly in your [affected.display_name]!",1)
	target.balloon_alert_to_viewers("Applying gel...")
	..()

/datum/surgery_step/open_encased/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	user.visible_message(span_notice("[user] applied \the [tool] to [target]'s [affected.encased]."), \
	span_notice("You applied \the [tool] to [target]'s [affected.encased]."))
	target.balloon_alert_to_viewers("Success")
	affected.surgery_open_stage = 2
