Config = {}

Config.AttackTypes = {
	{
		models = {
			`A_C_Alligator_01`,
			`MP_A_C_Alligator_01`
		},
		animation = {
			dict = "creatures_reptile@alligator@melee@streamed_core",
			name = "attack"
		},
		radius = 2.5,
		force = 2.0,
		damage = 25
	},
	{
		models = {
			`A_C_Alligator_02`
		},
		animation = {
			dict = "amb_creatures_reptile@gator_giant@nip_attack",
			name = "nip"
		},
		radius = 3.0,
		force = 2.0,
		damage = 25
	},
	{
		models = {
			`A_C_Badger_01`
		},
		animation = {
			dict = "creatures_mammal@badger@melee",
			name = "nip_attack"
		},
		radius = 2.0,
		force = 1.0,
		damage = 15
	},
	{
		models = {
			`A_C_Bear_01`,
			`A_C_BearBlack_01`,
			`MP_A_C_Bear_01`
		},
		animation = {
			dict = "creatures_mammal@bear@melee@streamed_core",
			name = "attack"
		},
		radius = 3.0,
		force = 5.0,
		damage = 30
	},
	{
		models = {
			`A_C_Beaver_01`,
			`MP_A_C_Beaver_01`
		},
		animation = {
			dict = "creatures_mammal@beaver@melee",
			name = "nip_attack"
		},
		radius = 2.0,
		force = 1.0,
		damage = 15
	},
	{
		models = {
			`A_C_Cougar_01`,
			`A_C_Panther_01`,
			`MP_A_C_Cougar_01`,
			`MP_A_C_Panther_01`
		},
		animation = {
			dict = "creatures_mammal@cougar@melee@streamed_core",
			name = "attack"
		},
		radius = 2.0,
		force = 3.0,
		damage = 20
	},
	{
		models = {
			`A_C_Coyote_01`,
			`MP_A_C_Coyote_01`
		},
		animation = {
			dict = "creatures_mammal@coyote@melee@streamed_core",
			name = "attack"
		},
		radius = 2.5,
		force = 2.0,
		damage = 25
	},
	{
		models = {
			`A_C_DogAmericanFoxhound_01`,
			`A_C_DogAustralianShepherd_01`,
			`A_C_DogBluetickCoonhound_01`,
			`A_C_DogCatahoulaCur_01`,
			`A_C_DogChesBayRetriever_01`,
			`A_C_DogCollie_01`,
			`A_C_DogHobo_01`,
			`A_C_DogHound_01`,
			`A_C_DogHusky_01`,
			`A_C_DogLab_01`,
			`A_C_DogLion_01`,
			`A_C_DogPoodle_01`,
			`A_C_DogRufus_01`,
			`A_C_DogStreet_01`,
			`MP_A_C_DogAmericanFoxhound_01`
		},
		animation = {
			dict = "creatures_mammal@dog_pers@melee@streamed_core",
			name = "attack"
		},
		radius = 2.5,
		force = 2.0,
		damage = 20
	},
	{
		models = {
			`A_C_Muskrat_01`
		},
		animation = {
			dict = "creatures_mammal@muskrat@melee",
			name = "nip_attack"
		},
		radius = 2.0,
		force = 1.0,
		damage = 15
	},
	{
		models = {
			`A_C_Raccoon_01`
		},
		animation = {
			dict = "creatures_mammal@raccoon@melee",
			name = "nip_attack"
		},
		radius = 2.0,
		force = 1.0,
		damage = 15
	},
	{
		models = {
			`A_C_Wolf`,
			`MP_A_C_Wolf_01`,
			`A_C_LionMangy_01`
		},
		animation = {
			dict = "creatures_mammal@wolf@melee@attacks@streamed_core",
			name = "attack"
		},
		radius = 3.0,
		force = 3.0,
		damage = 30
	},
	{
		models = {
			`A_C_Wolf_Medium`
		},
		animation = {
			dict = "creatures_mammal@wolf_medium@melee@attacks@streamed_core",
			name = "attack"
		},
		radius = 3.0,
		force = 3.0,
		damage = 25
	},
	{
		models = {
			`A_C_Wolf_Small`
		},
		animation = {
			dict = "creatures_mammal@wolf_small@melee@attacks@streamed_core",
			name = "attack"
		},
		radius = 3.0,
		force = 3.0,
		damage = 20
	}
}

Config.AttackCooldown = 2000

-- How long (ms) INPUT_ATTACK must be held to trigger a grab instead of an attack.
Config.CarryHoldTime = 600

-- Maximum grab distance in metres.
Config.CarryRadius = 2.0

-- Attachment offset from the carrier's head bone (local space: Y = forward, Z = down).
Config.CarryOffset   = vector3(0.0, 0.25, -0.08)
Config.CarryRotation = vector3(0.0, 0.0,  0.0)

-- Size class per animal model.
-- A ped can only carry animals whose size value is strictly lower than its own.
--   1 = tiny   (birds, rabbit, squirrel, frog …)
--   2 = small  (badger, beaver, raccoon, cat …)
--   3 = medium (dog, coyote, deer, boar …)
--   4 = large  (bear, cougar, wolf, alligator …)
Config.AnimalSizes = {
	-- Tiny (1)
	[`A_C_Bat`]              = 1,
	[`A_C_Chicken_01`]       = 1,
	[`A_C_ChickenHawk`]      = 1,
	[`A_C_Chipmunk_01`]      = 1,
	[`A_C_Cormorant`]        = 1,
	[`A_C_Crow`]             = 1,
	[`A_C_Duck`]             = 1,
	[`A_C_Eagle_Bald`]       = 1,
	[`A_C_Egret`]            = 1,
	[`A_C_Frog_01`]          = 1,
	[`A_C_Goose`]            = 1,
	[`A_C_Heron`]            = 1,
	[`A_C_Mockingbird`]      = 1,
	[`A_C_Opossum_01`]       = 1,
	[`A_C_Owl`]              = 1,
	[`A_C_Parrot`]           = 1,
	[`A_C_Pelican`]          = 1,
	[`A_C_Pigeon`]           = 1,
	[`A_C_Rabbit_01`]        = 1,
	[`MP_A_C_Rabbit_01`]     = 1,
	[`A_C_Rat`]              = 1,
	[`A_C_Rooster`]          = 1,
	[`A_C_Seagull`]          = 1,
	[`A_C_Snapping_Turtle`]  = 1,
	[`A_C_Songbird_01`]      = 1,
	[`A_C_Squirrel_01`]      = 1,
	[`A_C_Toad_01`]          = 1,
	[`A_C_Turkey_01`]        = 1,
	[`A_C_Woodpecker`]       = 1,
	-- Small (2)
	[`A_C_Armadillo_01`]     = 2,
	[`A_C_Badger_01`]        = 2,
	[`A_C_Beaver_01`]        = 2,
	[`MP_A_C_Beaver_01`]     = 2,
	[`A_C_Cat_01`]           = 2,
	[`A_C_Muskrat_01`]       = 2,
	[`A_C_Raccoon_01`]       = 2,
	[`A_C_Skunk_01`]         = 2,
	-- Medium (3)
	[`A_C_Boar_01`]          = 3,
	[`MP_A_C_Boar_01`]       = 3,
	[`A_C_Coyote_01`]        = 3,
	[`MP_A_C_Coyote_01`]     = 3,
	[`A_C_DogAmericanFoxhound_01`]    = 3,
	[`A_C_DogAustralianShepherd_01`]  = 3,
	[`A_C_DogBluetickCoonhound_01`]   = 3,
	[`A_C_DogCatahoulaCur_01`]        = 3,
	[`A_C_DogChesBayRetriever_01`]    = 3,
	[`A_C_DogCollie_01`]              = 3,
	[`A_C_DogHobo_01`]                = 3,
	[`A_C_DogHound_01`]               = 3,
	[`A_C_DogHusky_01`]               = 3,
	[`A_C_DogLab_01`]                 = 3,
	[`A_C_DogLion_01`]                = 3,
	[`A_C_DogPoodle_01`]              = 3,
	[`A_C_DogRufus_01`]               = 3,
	[`A_C_DogStreet_01`]              = 3,
	[`MP_A_C_DogAmericanFoxhound_01`] = 3,
	[`A_C_Goat_01`]          = 3,
	[`A_C_MuleDeer`]         = 3,
	[`A_C_Sheep_01`]         = 3,
	[`A_C_WhiteTailDeer_01`] = 3,
	-- Large (4)
	[`A_C_Alligator_01`]     = 4,
	[`MP_A_C_Alligator_01`]  = 4,
	[`A_C_Alligator_02`]     = 4,
	[`A_C_Bear_01`]          = 4,
	[`A_C_BearBlack_01`]     = 4,
	[`MP_A_C_Bear_01`]       = 4,
	[`A_C_Cougar_01`]        = 4,
	[`A_C_Panther_01`]       = 4,
	[`MP_A_C_Cougar_01`]     = 4,
	[`MP_A_C_Panther_01`]    = 4,
	[`A_C_LionMangy_01`]     = 4,
	[`A_C_Wolf`]             = 4,
	[`A_C_Wolf_Medium`]      = 4,
	[`A_C_Wolf_Small`]       = 4,
	[`MP_A_C_Wolf_01`]       = 4,
}
