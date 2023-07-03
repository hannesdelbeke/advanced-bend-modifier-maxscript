-- http://www.hourences.com/maxmaya-bending-of-modular-meshes/
-- thx to Sjoerd - Hourences for pointing me out this problem 
-- script by Hannes Delbeke
-- 16 May 2014 v 1.1
-- 9 May  2014 v 1.0

rollout stats "v1.1" --width:150 height:263
(
	label site "hannesdelbeke.com" 
	label mail "hannesdelbeke@gmail.com"
	label whitespace "" 
	label infopivot "If 90 and 180 degree have"
	label infopivot2 "different width, make sure"
 
	label infopivot3 "the pivot is in the right place"
	label whitespace2 "" 
	label lblOffset "Offset Center:-11.8986" 
	
	checkbox chkx "x" pos:[70,175] checked:true 
	checkbox chky "y" pos:[70,190] checked:true 
	checkbox chkz "z" pos:[70,205] checked:true 
	
	radioButtons rdoPos "" pos:[5,173] width:53 height:48 labels:#("center", "max", "min") default:3
	button btnSetPivot "Pivot" pos:[100,175] width:45 height:45 
	
	--button btnGrid "Snap to Grid" pos:[85,250] width:64 height:18 
	--spinner spnGrid "GridSize" pos:[20,250] 	width:65 height:16 range:[1,10000,64] 	type:#integer tooltip:"Grid Size"-- gridsze 
 	
	
	fn GetType3 obj=
	(		
		if chkx.checked then
		(		
			returnbool = False
			if rdoPos.state == 1 do --center
			(		
				x = obj.max.x - obj.min.x
				x = x/2
			)
			if rdoPos.state == 2 do --max
			(
				x = obj.max.x
			)
			if rdoPos.state == 3 do --min
			(
				x = obj.min.x
			)
			returnbool = True
		)
		else 
		(
			x = obj.pivot.x
		)
		if chky.checked then
		(
			if rdoPos.state == 1 do --center
			(	
				y = obj.max.y - obj.min.y
				y = y/2
			)
			if rdoPos.state == 2 do --max
			(
				y = obj.max.y
			)
			if rdoPos.state == 3 do --min
			(
				y = obj.min.y
			)		
			returnbool = True	
		)
		else
		(
			y = obj.pivot.y
		)
		if chkz.checked then
		(
			if rdoPos.state == 1 do --center
			(	
				
				z = obj.max.z - obj.min.z
				z = z/2
			)
			if rdoPos.state == 2 do --max
			(
				z = obj.max.z
			)
			if rdoPos.state == 3 do --min
			(
				z = obj.min.z
			)		
			returnbool = True	
		)
		else 
		(
			z = obj.pivot.z
		)
		if returnbool do
		return [x,y,z]
	)
	
	fn setPivot =
	(
		if selection != undefined do
		for obj in selection do
		(
			pos = [obj.pivot.x,obj.pivot.y,obj.pivot.z]
			pos = GetType3(obj)
			obj.pivot =pos
		)
	)
	
	on btnSetPivot pressed do
	(	
		setPivot()
	)
)
rollout BendFixRollout "BendFix Hannes" width:165 --height:301
(
	---------------------------------------Setup UI ----------------------------------------------
	
	button btnApply "New Bend Modifier" 		pos:[7,5] width:148 height:28 tooltip:"Add a bend modifier tothe selected objects if no bend modifier exists yet"
 
	--pos:[14,50] 
	GroupBox grpA "Angle"			pos:[5,35] width:154 height:44 
 
	checkbutton ckbA90 "90"		pos:[15,50] 	width:25 height:25 checked:true
	checkbutton ckbA180 "180" 	pos:[50,50] 	width:25 height:25
	checkbutton ckbA270 "270" 	pos:[85,50] 	width:25 height:25 -- enabled:false
	checkbutton ckbA360 "360" 	pos:[120,50] 	width:25 height:25
	
	GroupBox grpD "Direction" 	pos:[5,85] 	width:152 height:45
	
	checkbutton ckbD0 "0" 		pos:[15,100] 	width:25 height:25 checked:true
	checkbutton ckbD90 "90" 	pos:[50,100] 	width:25 height:25
	checkbutton ckbD180 "180" 	pos:[85,100] 	width:25 height:25
	checkbutton ckbD270 "270" 	pos:[120,100] width:25 height:25
	
	spinner spnHeight "" 			pos:[95,140] 	width:65 height:16 range:[0,16384,1024] type:#integer tooltip:"the initial height \n(the height without bend modifier active)\n\nVery Important\nIf this is wrong the script won`t work correctly "
	spinner spnGrid "" 				pos:[95,160] 	width:65 height:16 range:[1,10000,64] 	type:#integer tooltip:"Grid Size"-- gridsze 
	spinner spnWidth "" 			pos:[95,180] 	width:65 height:16 range:[0,16384,620] 	type:#integer tooltip:"if grid snap is active, it wil snap this width to the grid" enabled:false
	
	label lbl13 "Height" 								pos:[10,140] width:54 height:18	
	--checkbox chkLockHeight "" 		pos:[50,140] width:20 height:18 checked:false	
	checkbox chkSnapGrid "Grid Snap" 		pos:[10,160] width:79 height:18 checked:true	tooltip:"Activate grid snap\nwidth will snap to the closests multiplication of the grid size"	
	checkbox chkAutowidth "Manual width" 	pos:[10,180] width:85 height:18 checked:false	tooltip:"Disabled = automatic calculate final width\nEnabled = manual control over the final width" 
	
	label lblWidthPre "Final width" 	pos:[10,200] width:78 height:17 		
	label lblWidth "0" 					pos:[95,200] 	width:69 height:16 	
	
	--------------------------------------------------------------------------------------------------------	
	button btnGrid "Snap Pos to Grid" 	 width:148 height:28 tooltip:"Snaps the position of the selected objects to the grid"
	--spinner spnXpos "" 			pos:[95,180] 	width:65 height:16 range:[-9999999,9999999,620] 	type:#float
	fn	snapToGrid1 nr= 
	(	
		tempnr = nr as integer
		gridsize = spnGrid.value as integer
		quotient =tempnr/gridsize as integer
		roundedValue = quotient * gridsize as float
		gridfloat = gridsize as float
		if ( tempnr - roundedValue)> (gridfloat/2) then roundedValue += gridsize	
		return roundedValue
	)	
	fn	snapToGrid = 
	(	
		if selection != undefined do
		for obj in selection do
		(
			obj.pos.x = snapToGrid1(obj.pos.x)
			obj.pos.y = snapToGrid1(obj.pos.y)
			obj.pos.z = snapToGrid1(obj.pos.z)
		)
	)
	on btnGrid pressed do
	(	
		snapToGrid()
	)
	-------------------------------------------------------------------------------------------------------------
	
	---------------------------------------Variables ----------------------------------------------
	on btnApply rightclick do 
	(
		DestroyDialog stats
		createDialog stats
	)
	
	local offset = 0f	
	local offsetVector = [0,0,0]
	local obj = $
	local height = 1024
	--local divideconstant = -86.0576519035213
	local divideconstant = -86.0602056878460272632506284428750874459128685735009
	local direction = 0
	local myangle = 90
	local rawwidth = 620
	local width = 620
	local snapGrid = true
	local autowidth = true
	local gridsize = 64
	local selectionlist
	
	---------------------------------------- Functions ----------------------------------------
	
	fn newSelection =
	(
		/*
			callbacks.removeScripts #viewportChange
			callbacks.addscript #viewportChange "RefManager.smartHide()"  id:#updateVport
		*/
		
		-- update guess height
		-- update angle and direction
		--deactivate buttons if non supported direction or angle, popup message		
	)
	
	fn calculateWidth = (
		if autowidth then 
		(
			if myangle == 90 then
			(
				width = 2 * height / pi
			)
			else if myangle == 180 then
			(
				width = 2 * height / pi
			)
			else if myangle == 270 then
			(
				width = 4 * height/ ( 3 * pi )
			)
			else if myangle == 360 then
			(
				width = height / pi
			)	
			else print "unsupported angle"		
		)
	)
	
	fn autosnapWidth = 
	(		
		if snapGrid then 
		(
			calculateWidth()
			tempgridsize = gridsize as integer -- if not as int it doesnt work!
				
			ww = rawwidth as integer
			quotient = ww/tempgridsize
			width = quotient * tempgridsize as float
			gridfloat = tempgridsize as float
			if ( ww - width)> (gridfloat/2) then width += tempgridsize	
		)	
		else
		(
			width = rawwidth	
		)
		lblWidth.text = width as string	
	)
	
	fn changeDirection = (
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then		
				i.modifiers[#Bend].BendDir = direction		
		)
	)
	
	fn loadDirection =
	(			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	(
			for i in selectionlist do (
				myangle = i.modifiers[#Bend].BendAngle 
				direction = i.modifiers[#Bend].BendDir 	
			)				
		)
		if myangle <0 then (
			myangle = -1 * myangle
			direction += 180			
		)
		while direction >= 360 do  direction -= 360		
	)
	fn calculateOffset = 
	( -- not tested with negative angles
		autosnapWidth()
		
		minus = -1
		if myangle < 0 then minus = 1 			
		
		/*
		divconst = divideconstant
		if myangle == 180 then divconst *= 2
--		if myangle == 270 then divconst *= 3
		if myangle == 360 then divconst *= 4			
		offset = height/divconst
		*/
		
		if myangle == 90 then 
		(
			offset = width as float
			--print "------------------"
			--print offset
			--print pi
		--	print  ( (2 * height) / pi)
		--	test = 2 * height as float
		--	offset = width - ( test / pi ) as float
			--offset -= ((2 * height )/ pi) as float
			offset = width - (2 * height )/ pi as float
			
			--print "offset"
			--print offset
			--print "--------------"
		)
		else if myangle == 180 then
		(
			offset = width/2 - height / pi as float
		)		
		else if myangle == 270 then 
		(
			offset = width / 2 -  2 * height / ( 3 * pi ) as float
		)		
		else if myangle == 360 then 
		(
			offset = width / 2 - height /2 / pi as float
		)
		
		
		
		
		if direction == 0 then
			offsetVector = [ -1 * offset * minus , 0 , 0] 
		if direction == 180 then
			offsetVector = [ offset * minus , 0 , 0]	
		if direction == 90 then
			offsetVector = [  0 ,offset * minus , 0] 
		if direction == 270 then
			offsetVector = [ 0 , -1 * offset * minus , 0]  		
		--print offsetVector		
		temp = offset as string
		stats.lblOffset.text = "Offset Center:" + temp	
		
		lblWidth.text = width as string		
	)
	fn offsetBend =
	(		
		calculateOffset()
		selectionlist = getCurrentSelection()		
		if $ != undefined then
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then		
				(
					i.modifiers[#Bend].BendDir = direction
					--calculateOffset()
					i.modifiers[#Bend].center = offsetVector
					-- update label
					--print offsetVector
					--print i.modifiers[#Bend].center
				)
			)
	)	
	/*
	fn updateSpinners = 
	(
		--calculateOffset()
		offsetBend()
	--	if snapGrid then
	--	spnWidth.value = width -- temp solution, will swap with label
	)*/
	---------------------------------------- UI functions --------------------------------------
	
	on btnApply pressed do
	(				
		selectionlist = getCurrentSelection()		
		if $ != undefined then	(
			for i in selectionlist do (
				if i.modifiers[#Bend] == undefined then
				(
					modPanel.addModToSelection (Bend ()) ui:on
					i.modifiers[#Bend].BendAngle = myangle
					 --$.modifiers[#Bend].BendDir = direction
					i.modifiers[#Bend].BendAxis = 2
					i.modifiers[#Bend].FromTo = off
					offsetBend()
				)
				else
				--print "already bend"
				offsetBend()
			)
		) else messageBox "Please select something"
	)
	on ckbA90 changed a do
	(		
		ckbA90.checked = true	
		myangle =90
		
		ckbA180.checked = false	
		ckbA270.checked = false	
		ckbA360.checked = false
		
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then	(	
					i.modifiers[#Bend].BendAngle = myangle		
					offsetBend()
				)
			)
	)
	on ckbA180 changed a do
	(		
		ckbA180.checked = true	
		myangle = 180
		
		ckbA90.checked = false	
		ckbA270.checked = false	
		ckbA360.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then	(
					i.modifiers[#Bend].BendAngle = myangle
					offsetBend()
				)
			)
	)
	on ckbA270 changed a do
	(		
		ckbA270.checked = true	
		myangle = 270
		
		ckbA180.checked = false	
		ckbA90.checked = false	
		ckbA360.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then	(
					i.modifiers[#Bend].BendAngle = myangle
					offsetBend()
				)
			)
	)
	on ckbA360 changed a do
	(		
		ckbA360.checked = true	
		myangle = 360
		
		ckbA180.checked = false	
		ckbA270.checked = false	
		ckbA90.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then	(
					i.modifiers[#Bend].BendAngle = myangle
					offsetBend()
				)
			)
	)
	on ckbD0 changed a do
	(		
		ckbD0.checked = true	
		direction = 0
		
		ckbD90.checked = false	
		ckbD180.checked = false	
		ckbD270.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then				
				offsetBend()
			)
	)
	on ckbD90 changed a do
	(		
		ckbD90.checked = true	
		direction = 90
		
		ckbD0.checked = false	
		ckbD180.checked = false	
		ckbD270.checked = false
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then				
				offsetBend()
			)
	)
	on ckbD180 changed a do
	(		
		ckbD180.checked = true	
		direction = 180
		
		ckbD90.checked = false	
		ckbD0.checked = false	
		ckbD270.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then				
				offsetBend()
			)
	)
	on ckbD270 changed a do
	(		
		ckbD270.checked = true	
		direction = 270
		
		ckbD90.checked = false	
		ckbD180.checked = false	
		ckbD0.checked = false	
			
		selectionlist = getCurrentSelection()		
		if $ != undefined then	
			for i in selectionlist do (
				if i.modifiers[#Bend] != undefined then				
				offsetBend()
			)
	)
	on spnHeight changed a do
	(				
		height = a				
		offsetBend()
	)	
	on chkAutowidth changed a do
	(
		-- if a true then manual control
		autowidth = not a		
		spnWidth.enabled = a	
	)
	on chkSnapGrid changed a do
	( 
		snapGrid = a
		spnGrid.enabled = snapGrid
		
		lblWidth.text = width as string		
		offsetBend()
	) 
	on spnWidth changed a do
	(	
		if autowidth== false then  (			
			rawwidth = a
		)
		offsetBend() 	
	)
	on spnGrid changed b do
	(	
		gridsize = b
		offsetBend()
	)
)

createDialog BendFixRollout
--print "SELECTION -------"
BendFixRollout.selectionlist = getCurrentSelection()
--print BendFixRollout.selectionlist 
BendFixRollout.calculateOffset()
BendFixRollout.autosnapWidth()		
BendFixRollout.offsetBend()
