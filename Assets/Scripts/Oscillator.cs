using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Oscillator : MonoBehaviour {

	public Vector3 axis;
	public float cycle_time = 1;
	
	// Update is called once per frame
	void Update () {
		this.transform.position += axis * Mathf.Sin (Time.time * cycle_time);
	}
}
