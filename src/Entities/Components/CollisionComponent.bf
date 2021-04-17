using System;
using System.Collections;
namespace Atma.Entities.Components
{
	public class CollisionComponent : Component
	{
		public bool isEnabled = true;
		private aabb2 _local_bounds;
		public static List<CollisionComponent> collisions {public get; set;}

		public this(bool active = false) : base(active)
		{
			if(collisions == null)
				collisions = new List<CollisionComponent>();
			collisions.Add(this);
		}

		public ~this()
		{
			collisions.Remove(this);
			if(collisions.Count == 0)
			{
				delete(collisions);
				collisions = null;
			}
		}

		public aabb2 LocalBounds
		{
			get
			{
				return _local_bounds;
			}
			set
			{
				_local_bounds = value;
			}
		}
		public aabb2 WorldBounds
		{
			get
			{
				var bounds = LocalBounds;
				bounds.Center = Entity.WorldPosition;
				return bounds;
			}
		}

		public float Width => _local_bounds.Width;
		public float Height => _local_bounds.Height;
	}
}
