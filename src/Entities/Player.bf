using Atma;
using SDL2;
using System.IO;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class Player : Entity
	{
		public class PlayerInput
		{
			private VirtualAxis _aimX = new .() ~delete _;
			private VirtualAxis _aimY = new .() ~delete _;
			private bool gamePad = false;

			public VirtualButton mouseDown = new .() ~delete _;
			public const float DeadZone = 0.20f;

			public this()
			{
				_aimX.AddAxis(0, .RightX, DeadZone);
				_aimY.AddAxis(0, .LeftX, DeadZone);
				mouseDown.AddMouseButton(.Left);
				//mouseDown.Repeat(0, 1);
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

		public this(Scene scene) : base("Player")
		{
			input_manager = scene.AddEntity(new InputManager());
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
			input_manager.input_axis = input.Aim;
		}

		protected override void OnFixedUpdate()
		{
			base.OnFixedUpdate();
			input.Update(WorldPosition);
		}
	}
}
