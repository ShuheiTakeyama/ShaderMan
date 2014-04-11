using UnityEngine;
using System.Collections;

public class SimpleTexturingRotation : MonoBehaviour 
{
	private float y = 0.0f;

	void Update ()
	{
		y += 1.0f;
		Quaternion rotation = Quaternion.Euler (new Vector3 (0.0f, y, 0.0f));
		transform.rotation = rotation;
	}
}
