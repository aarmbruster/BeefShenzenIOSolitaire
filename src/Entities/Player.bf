using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class Player : Entity
	{
		public class PlayerInput
		{
			private VirtualAxis _aimX = new .() ~delete _;
			private VirtualAxis _aimY = new .() ~delete _;

			public VirtualButton mouseDown = new .() ~delete _;

			public const float DeadZone = 0.20f;

			private bool gamePad = false;

			

			public this()
			{
				_aimX.AddAxis(0, .RightX, DeadZone);
				_aimY.AddAxis(0, .LeftX, DeadZone);
				mouseDown.AddMouseButton(.Left);
				mouseDown.Repeat(0, 0);
			}

			public void Update(float2 worldPosition)
			{
				//Aim = float2(Screen.Mouse - worldPosition).NormalizedSafe;
				Aim = float2(Screen.Mouse - worldPosition);
				
				
			}

			public float2 Aim;
		}

		private PlayerInput input = new .() ~ Release(_);
		private InputManager input_manager;

		public this(InputManager input_manager) : base("Player")
		{
			this.input_manager = input_manager;
		}

		protected override void OnUpdate()
		{
			if(input.mouseDown.Pressed)
			{
				Console.WriteLine("MouseDown");
			}
			base.OnUpdate();
		}

		protected override void OnFixedUpdate()
		{
			base.OnFixedUpdate();
			input.Update(WorldPosition);
			
			//var aim = input.Aim;
			//Console.WriteLine("X:{} Y:{}", aim.x, aim.y);
		}
	}
}
