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

			public const float DeadZone = 0.20f;

			private bool gamePad = false;

			public this()
			{
				_aimX.AddAxis(0, .RightX, DeadZone);
				_aimY.AddAxis(0, .LeftX, DeadZone);
			}

			public void Update(float2 worldPosition)
			{
				Aim = float2(Screen.Mouse - worldPosition).NormalizedSafe;
			}

			public float2 Aim;
		}

		private PlayerInput input = new .() ~ Release(_);

		public this() : base("Player")
		{

		}

		protected override void OnFixedUpdate()
		{
			input.Update(WorldPosition);
			//var aim = input.Aim;
			//Console.WriteLine("X:{} Y:{}", aim.x, aim.y);
		}
	}
}
