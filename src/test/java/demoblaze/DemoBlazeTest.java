package demoblaze;

import com.intuit.karate.junit5.Karate;

class DemoBlazeTest {

    @Karate.Test
    Karate auth() {
        return Karate.run("auth").relativeTo(getClass());
    }
}
