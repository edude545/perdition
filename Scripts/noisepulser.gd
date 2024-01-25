extends TextureRect

@export var oscillators: Array[Oscillator]

func _physics_process(delta):
	for osc in oscillators:
		var obj = self
		for varname in osc.varpath.slice(0,osc.varpath.size()-1):
			obj = obj.get(varname)
		obj.set(osc.varpath[-1], osc.process(delta))
		texture.noise.offset.z = Time.get_ticks_msec() / 400.0
