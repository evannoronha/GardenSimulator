
import java.io.Serializable;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "rootPlant")
@SessionScoped
@ManagedBean
public class RootPlant extends PlantSpecies implements Serializable {

    public RootPlant() {
        super();
    }

}
