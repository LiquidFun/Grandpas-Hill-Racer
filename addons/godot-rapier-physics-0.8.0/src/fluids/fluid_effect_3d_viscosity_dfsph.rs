use godot::prelude::*;
#[derive(GodotClass)]
#[class(base=Resource)]
pub struct FluidEffect3DViscosityDFSPH {
    #[export]
    fluid_viscosity_coefficient: real,

    base: Base<Resource>,
}
#[godot_api]
impl IResource for FluidEffect3DViscosityDFSPH {
    fn init(base: Base<Resource>) -> Self {
        Self {
            fluid_viscosity_coefficient: 1.0,
            base,
        }
    }
}
