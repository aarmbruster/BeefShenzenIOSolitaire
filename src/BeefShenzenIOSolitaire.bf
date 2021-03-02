using Atma;
using System;
using BeefShenzenIOSolitaire.Entities;


namespace BeefShenzenIOSolitaire
{
	public class BeefShenzenIOSolitaire : Scene
	{

		public Player player;
		public Card card;
		public Background background;

		public SpecialButton bamboo_btn;

		public this() : base(.ExactFit, Screen.Size)
		{
			Time.SetTargetFramerate(120);

			Core.Atlas.AddDirectory("main", "textures");
			Core.Atlas.AddDirectory("main", "textures/large_icons");
			Core.Atlas.AddDirectory("main", "textures/small_icons");
			Core.Atlas.Finalize();

			player = AddEntity(new Player());
			background = AddEntity(new Background());
			card = AddEntity(new Card());
			card.Position = float2(200.0f, 200.f);

			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_green_up"], 	float2(533, 53)));
			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_red_up"], 		float2(533, 137)));
			bamboo_btn = AddEntity(new SpecialButton(Core.Atlas["main/button_white_up"], 	float2(533, 219)));
			
			this.Camera.AddRenderer(new SceneRenderer(this) { });
		}

		public override void FixedUpdate()
		{
			ImGui.ShowMetricsWindow();
			base.FixedUpdate();
		}
	}
}
