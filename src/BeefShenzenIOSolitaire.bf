using Atma;
using System;
using BeefShenzenIOSolitaire.Entities;


namespace BeefShenzenIOSolitaire
{
	public class BeefShenzenIOSolitaire : Scene
	{

		public Player player;
		public Background background;

		public SpecialButton bamboo_btn;
		private CardManager card_manager = new CardManager() ~Release(_);
		public this() : base(.ExactFit, Screen.Size)
		{
			Time.SetTargetFramerate(60);

			Core.Atlas.AddDirectory("main", "textures");
			Core.Atlas.AddDirectory("main", "textures/large_icons");
			Core.Atlas.AddDirectory("main", "textures/small_icons");
			Core.Atlas.Finalize();

			let input_manager = AddEntity(new InputManager());
			player = AddEntity(new Player(input_manager));
			background = AddEntity(new Background());

			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_green_up"], 	float2(533, 53)));
			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_red_up"], 		float2(533, 137)));
			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_white_up"], 	float2(533, 219)));

			card_manager = new CardManager();
			card_manager.place_cards(this);

			this.Camera.AddRenderer(new SceneRenderer(this) { });
		}

		public ~this()
		{
			//delete(card_manager);
		}

		public override void FixedUpdate()
		{
			base.FixedUpdate();
		}
	}
}
